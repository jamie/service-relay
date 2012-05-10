require './test/test_helper'
require './lib/salesforce_pivotal_formatter'

CASES = [
{"Id"=>"5006000000J9EBuAAN",
  "Status"=>"Escalated--Defect",
  "CreatedDate"=>"2012-05-08T01:45:28.000+0000",
  "SuppliedName"=>"no-reply@versapay.com",
  "attributes"=>
   {"url"=>"/services/data/v24.0/sobjects/Case/5006000000J9EBuAAN",
    "type"=>"Case"},
  "Description"=>
   "From: Hendrik Kueck\r\nEmail: hendrik@pocketpixels.com\r\n\r\nPDF filename restrictions\r\n------------------------------\r\n\r\nHi,\r\nI love your system overall!\r\n\r\nThe one minor issue that repeatedly annoys me though is that your system refuses PDFs with \"special characters\". \r\nI feel that in 2012 that isn't really acceptable anymore. \r\nFor example the filenames generated by the CRA's payroll deductions calculator are rejected. Such as: \r\n\"Jan Kruse -(EE)-PDOC-Date paid- 2012-02-29.pdf\"\r\n\r\nIt'd be great if you could fix this. \r\n\r\nThank you,\r\nHendrik\r\n\r\n--\r\n\r\n \r\n \r\n Name\r\n \r\n \r\n \r\n \302\240\r\n \r\n Hendrik Kueck\r\n \r\n \r\n \r\n Email\r\n \r\n \r\n \r\n \302\240\r\n \r\n hendrik@pocketpixels.com\r\n \r\n \r\n \r\n Subject\r\n \r\n \r\n \r\n \302\240\r\n \r\n PDF filename restrictions\r\n \r\n \r\n \r\n Description\r\n \r\n \r\n \r\n \302\240\r\n \r\n Hi,\r\nI love your system overall!\r\n\r\nThe one minor issue that repeatedly annoys me though is that your system refuses PDFs with \"special characters\". \r\nI feel that in 2012 that isn't really acceptable anymore. \r\nFor example the filenames generated by the CRA's payroll deductions calculator are rejected. Such as: \r\n\"Jan Kruse -(EE)-PDOC-Date paid- 2012-02-29.pdf\"\r\n\r\nIt'd be great if you could fix this. \r\n\r\nThank you,\r\nHendrik",
  "SuppliedCompany"=>nil,
  "Subject"=>"PDF filename restrictions"},
 {"Id"=>"5006000000J9kt5AAB",
  "Status"=>"Escalated--Feature",
  "CreatedDate"=>"2012-05-10T14:55:52.000+0000",
  "SuppliedName"=>"Andrea Peattie",
  "attributes"=>
   {"url"=>"/services/data/v24.0/sobjects/Case/5006000000J9kt5AAB",
    "type"=>"Case"},
  "Description"=>
   "edwin kwong\r\n\r\n*Email or phone number*\r\n\r\n\r\n\r\nedwin@vsoschoolofmusic.ca\r\n\r\n*Comments*\r\n\r\n\r\n\r\nHi,\r\n\r\nEarlier today I sent a note regarding whether you have dual authorization\r\nabilities on VERSAPAY. Currently we use your system to make payments, but\r\nour auditors have requested to see if we can change to dual authority to\r\nmatch our policies. Please contact me via email or phone as soon as\r\npossible via 604-915-9300 x112\r\n\r\n\r\n\r\nfrom:206.108.24.210\r\n\r\n\r\n\r\n\r\n\r\n-- \r\n\r\n*Kevin Short*\r\n\r\nChief Information Officer\r\n\r\n\r\n\r\n*VersaPay Corporation*\r\n\r\n1150-1500 West Georgia Street\r\n\r\nVancouver, BC V6G 2Z6\r\n\r\n\r\n\r\n604-909-9848  Direct\r\n\r\n866-999-8729  Toll-Free, Ext. 1101\r\n\r\n604-678-3538  Fax\r\n\r\n\r\n\r\nversapay.com | versapay.com/blog | twitter.com/versapay",
  "SuppliedCompany"=>nil,
  "Subject"=>"Dual Approval"}
]

EXPECTED_XML = <<XML
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<external_stories type=\"array\">
  <external_story>
    <external_id>5006000000J9EBuAAN</external_id>
    <name>PDF filename restrictions</name>
    <description>From: Hendrik Kueck\r\nEmail: hendrik@pocketpixels.com\r\n\r\nPDF filename restrictions\r\n------------------------------\r\n\r\nHi,\r\nI love your system overall!\r\n\r\nThe one minor issue that repeatedly annoys me though is that your system refuses PDFs with \"special characters\". \r\nI feel that in 2012 that isn't really acceptable anymore. \r\nFor example the filenames generated by the CRA's payroll deductions calculator are rejected. Such as: \r\n\"Jan Kruse -(EE)-PDOC-Date paid- 2012-02-29.pdf\"\r\n\r\nIt'd be great if you could fix this. \r\n\r\nThank you,\r\nHendrik\r\n\r\n--\r\n\r\n \r\n \r\n Name\r\n \r\n \r\n \r\n &#160;\r\n \r\n Hendrik Kueck\r\n \r\n \r\n \r\n Email\r\n \r\n \r\n \r\n &#160;\r\n \r\n hendrik@pocketpixels.com\r\n \r\n \r\n \r\n Subject\r\n \r\n \r\n \r\n &#160;\r\n \r\n PDF filename restrictions\r\n \r\n \r\n \r\n Description\r\n \r\n \r\n \r\n &#160;\r\n \r\n Hi,\r\nI love your system overall!\r\n\r\nThe one minor issue that repeatedly annoys me though is that your system refuses PDFs with \"special characters\". \r\nI feel that in 2012 that isn't really acceptable anymore. \r\nFor example the filenames generated by the CRA's payroll deductions calculator are rejected. Such as: \r\n\"Jan Kruse -(EE)-PDOC-Date paid- 2012-02-29.pdf\"\r\n\r\nIt'd be great if you could fix this. \r\n\r\nThank you,\r\nHendrik</description>
    <requested_by>no-reply@versapay.com</requested_by>
    <created_at type=\"datetime\">2012/05/07 18:45:28 UTC</created_at>
    <story_type>bug</story_type>
    <estimate type=\"integer\">-1</estimate>
  </external_story>
  <external_story>
    <external_id>5006000000J9kt5AAB</external_id>
    <name>Dual Approval</name>
    <description>edwin kwong\r\n\r\n*Email or phone number*\r\n\r\n\r\n\r\nedwin@vsoschoolofmusic.ca\r\n\r\n*Comments*\r\n\r\n\r\n\r\nHi,\r\n\r\nEarlier today I sent a note regarding whether you have dual authorization\r\nabilities on VERSAPAY. Currently we use your system to make payments, but\r\nour auditors have requested to see if we can change to dual authority to\r\nmatch our policies. Please contact me via email or phone as soon as\r\npossible via 604-915-9300 x112\r\n\r\n\r\n\r\nfrom:206.108.24.210\r\n\r\n\r\n\r\n\r\n\r\n-- \r\n\r\n*Kevin Short*\r\n\r\nChief Information Officer\r\n\r\n\r\n\r\n*VersaPay Corporation*\r\n\r\n1150-1500 West Georgia Street\r\n\r\nVancouver, BC V6G 2Z6\r\n\r\n\r\n\r\n604-909-9848  Direct\r\n\r\n866-999-8729  Toll-Free, Ext. 1101\r\n\r\n604-678-3538  Fax\r\n\r\n\r\n\r\nversapay.com | versapay.com/blog | twitter.com/versapay</description>
    <requested_by>Andrea Peattie</requested_by>
    <created_at type=\"datetime\">2012/05/10 07:55:52 UTC</created_at>
    <story_type>feature</story_type>
    <estimate type=\"integer\">-1</estimate>
  </external_story>
</external_stories>
XML

describe SalesforcePivotalFormatter do
  it "converts basic to xml" do
    basic_case = {"Id"=>"5006000000J9EBuAAN",
      "Status"=>"Escalated--Defect",
      "CreatedDate"=>"2012-05-08T01:45:28.000+0000",
      "SuppliedName"=>"no-reply@versapay.com",
      "attributes"=>
      {  "url"=>"/services/data/v24.0/sobjects/Case/5006000000J9EBuAAN",
        "type"=>"Case"
      },
      "Description"=>"This is the description",
      "SuppliedCompany"=>nil,
      "Subject"=>"PDF filename restrictions"
    }
    xml = <<XML
<?xml version="1.0" encoding="UTF-8"?>
<external_stories type="array">
  <external_story>
    <external_id>5006000000J9EBuAAN</external_id>
    <name>PDF filename restrictions</name>
    <description>This is the description</description>
    <requested_by>no-reply@versapay.com</requested_by>
    <created_at type="datetime">2012/05/07 18:45:28 UTC</created_at>
    <story_type>bug</story_type>
    <estimate type="integer">-1</estimate>
  </external_story>
</external_stories>
XML
    SalesforcePivotalFormatter.new([basic_case]).to_xml.must_equal(xml)
  end

  it "converts complex to xml" do
    SalesforcePivotalFormatter.new(CASES).to_xml.must_equal(EXPECTED_XML)
  end
end

