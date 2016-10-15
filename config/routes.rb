Rails.application.routes.draw do
	root "preferences#index"
	get "show_results" => "preferences#show_results"
end
