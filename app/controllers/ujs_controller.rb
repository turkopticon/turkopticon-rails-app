class UjsController < ApplicationController
  include AB::Core

  def new_flag
    @options = [
        'Rule violation: insults worker or requester',
        'Rule violation: profanity/racism',
        'Rule violation: threat or incitement of violence',
        'Rule violation: discloses details about screener',
        'Rule violation: EXCESSIVE CAPS or ASCII art',
        'Review manipulation: possible requester self-review',
        'Review manipulation: malicious review or falsifies information',
        'Other: review inconsistency',
        'Other: incorrectly claims TOS violation'
    ]

    @variant = ab(:ab_nflockup, { command: 'flags/new', question: 'flags/new_abv2' })
  end
end