module Mailers
  class InquiryMailer < ActionMailer::Base
  
    default from: "noreply@newavenuehomes.com"

    def submission_email(inquiry)
      @inquiry = inquiry
      mail(
        :to => Rails.application.config.inquiry_recipients, 
        :subject => "Inquiry Submission from #{@inquiry.first_name} #{@inquiry.last_name} (from #{Rails.env} site)"
      )
    end

  end
end