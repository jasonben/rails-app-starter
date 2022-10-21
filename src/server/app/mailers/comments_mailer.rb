# frozen_string_literal: true

# top level comment
class CommentsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.comments_mailer.submitted.subject
  #
  def submitted(comment)
    @comment = comment

    mail to: "bloggie@example.org", subject: "New comment!"
  end
end
