module Api
  module V1
    class ReposController < ApplicationController
      protect_from_forgery with: :null_session
      respond_to :json

      def pending
        if request.headers["x-api-key"] != ENV["GRADER_TOKEN"]
          render nothing: true, status: :forbidden
          return
        end

        forks = AutomaticCorrection::Repo.where(pending: true).where.not(parent: nil).order(updated_at: :asc)

        respond_with forks.to_json(only: [:id, :user, :name, :git_url ],
                                  include: {
                                      parent: { only: [:user, :name, :git_url ] }
                                  })
      end

      def grade
        if request.headers["x-api-key"] != ENV["GRADER_TOKEN"]
          render nothing: true, status: :forbidden
          return
        end

        #TODO: considerar que puede no haber una corrección pendiente (falla el grader?)
        #TODO: utilizar ese SHA para algo
        #TODO: metemos un rescue para los casos no contemplados? Se vuelve atras todo?

        fork = AutomaticCorrection::Repo.find(params[:id])

        test_run = AutomaticCorrection::TestRun.create(
          score: params[:test_run][:score],
          git_commit_id: params[:test_run][:sha]
          # detalles!
        )
        fork.test_runs << test_run

        #TODO(delucas): ojo, puede haber DETALLES si es que hay errores, o cosas similares
        # el caso que contemplo en el que puede no haber resultados, es si no pudo corregir x error de compilacion
        if params[:test_run][:results]
          params[:test_run][:results].each do |result|

            res = AutomaticCorrection::Result.create(
              test_type: result[:type],
              score: result[:score]
            )
            test_run.results << res

            result[:issues].each do |issue|
              iss = AutomaticCorrection::Issue.create(issue_params(issue))
              res.issues << iss
            end

          end
        end

        fork.update_attributes(pending: false)

        # TODO: handle errors here
        head :ok
      end

      private
        def issue_params(issue)
          issue.permit!
        end
    end
  end
end
