class Api::V1::NotesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  before_action :set_note, only: [:update, :destroy]

  def index
    notes = Note.search_by_term(params[:q])
                .order(created_at: :desc)
                .page(params[:page])
                .per(20)

    render json: {
      notes: notes,
      meta: pagination_meta(notes)
    }
  end

  def create
    note = Note.new(note_params)

    if note.save
      render json: note, status: :created
    else
      render json: { errors: note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @note.update(note_params)
      render json: @note
    else
      render json: { errors: @note.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @note.destroy

    head :no_content
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end

  def record_not_found
    render json: { error: 'Nota não encontrada' }, status: :not_found
  end

  def pagination_meta(notes)
    {
      current_page: notes.current_page,
      total_pages: notes.total_pages,
      total_count: notes.total_count
    }
  end
end