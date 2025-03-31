class Api::V1::ViewingPartiesController < ApplicationController
  def create
    viewing_party = ViewingParty.new(viewing_party_params)
    if viewing_party.save
      render json: ViewingPartySerializer.serialize(viewing_party), status: :created
    else
      render json: ErrorSerializer.format_error(ErrorMessage.new(user.errors.full_messages.to_sentence, 400)), status: :bad_request
    end
  end

  def update
    viewing_party = ViewingParty.find(params[:id])

    new_invitee = params[:invitees_user_id].to_i

    viewing_party.add_invitee(new_invitee)

    render json:ViewingPartySerializer.serialize(viewing_party), status: :ok
  end

  def viewing_party_params
    params.permit(:id, :invitees_user_id, :name, :start_time, :end_time, :movie_id, :movie_title, :host_id, invitees: [])
  end
end