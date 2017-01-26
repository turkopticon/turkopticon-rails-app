class UjsController < ApplicationController
  def new_flag
    @options = [
        'Rule violation: insults worker or requester',
        'Rule violation: profanity/racism',
        'Rule violation: threat or incitement of violence',
        'Rule violation: discloses details about screener',
        'Review manipulation: possible requester self-review',
        'Review manipulation: suspicious review; see reviewer\'s other reviews',
        'Other: review inconsistency',
        'Other: incorrectly claims TOS violation'
    ]
  end
end