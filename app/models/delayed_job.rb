class DelayedJob < ActiveRecord::Base
  attr_accessible :priority, :attempts, :handler,    :last_error, :run_at ,   :locked_at,  :failed_at,  :locked_by,  :queue
end