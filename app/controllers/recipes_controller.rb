class RecipesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    # rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

    def create
        user = User.find(session[:user_id])
        recipe = Recipe.create(user_id: user.id, title: recipe_params[:title], instructions: recipe_params[:instructions], minutes_to_complete: recipe_params[:minutes_to_complete])
        if recipe.valid?
            render json: recipe, status: :created
        else
            render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
    end

    def index
        user = User.find(session[:user_id])
        recipes = Recipe.all
        render json: recipes, status: 200
    end

    private
    def recipe_params
      params.permit(:user_id, :title, :instructions, :minutes_to_complete)
    end

    def record_not_found
        render json: { errors: ["Not Authorized"] }, status: 401
    end

    # def render_unprocessable_entity_response(invalid)
    # render json: { errors: invalid.record.errors }, status: :unprocessable_entity
    # end

end
