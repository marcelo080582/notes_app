class Api::V1::NotesController < ApplicationController
  before_action :set_note, only: [:update, :destroy]

  def index
    notes = Note.order(created_at: :desc).page(params[:page]).per(3)

    render json: {
      notes: notes,
      meta: {
        current_page: notes.current_page,
        total_pages: notes.total_pages,
        total_count: notes.total_count
      }
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
end