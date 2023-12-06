require "test_helper"

class Upvs::MessageTemplateTest < ActiveSupport::TestCase
  test 'builds XML form for message draft' do
    message_draft = MessageDraft.new
    message_template = upvs_message_templates(:general_agenda)

    message_template.create_message(message_draft, author: users(:basic), box: boxes(:ssd_main), recipient_uri: 'ico://sk/12345678')

    message_draft.metadata['data'] = {
      Predmet: 'Odpoveď',
      Text: 'Odpoveď k rozhodnutiu...'
    }
    message_draft.save

    message_template.build_message_from_template(message_draft)

    assert_equal '<GeneralAgenda xmlns="http://schemas.gov.sk/form/App.GeneralAgenda/1.9"> <subject>Odpoveď</subject> <text>Odpoveď k rozhodnutiu...</text> </GeneralAgenda>', message_draft.form.message_object_datum.blob
  end
end
