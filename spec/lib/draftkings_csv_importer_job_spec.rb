require "minitest/autorun"
require "active_job"
require "active_record"
require_relative "../app/jobs/draftkings_csv_importer_job"
require_relative "../app/models/user"




class TestDraftkingsCsvImporter < Minitest::Test

  def setup
    @csv_1 = <<-eos
    "Sport","Entry","Contest_Date_EST","Place","Points","Winnings_Non_Ticket","Winnings_Ticket","Contest_Entries","Entry_Fee","Prize_Pool","Places_Paid"
    "MLB","MLB $5.5K Moon Shot [$5,500 Guaranteed] (3/50)","2014-05-24 19:15:00",922,96.15,"$0.00","$0.00",2434,"$2.00","$5,500.00",650
    "MLB","MLB $2 Head-to-Head vs. yudarvish","2014-05-24 19:15:00",1,68.3,"$3.60","$0.00",2,"$2.00","$3.60",1
    "MLB","MLB $2 Head-to-Head vs. yudarvish","2014-05-24 19:15:00",2,68.3,"$0.00","$0.00",2,"$2.00","$3.60",1
    eos

    @csv2 = <<-eos
    "Sport","Entry","Contest_Date_EST","Place","Points","Winnings_Non_Ticket","Winnings_Ticket","Contest_Entries","Entry_Fee","Prize_Pool","Places_Paid"
    "MLB","MLB $5 Triple Up [Top 12 Win $15]","2014-05-24 19:15:00",16,96.15,"$0.00","$0.00",33,"$5.00","$180.00",12
    "MLB","MLB BIG $5 50/50 [Top 50% Win]","2014-05-24 19:15:00",144,68.3,"$0.00","$0.00",155,"$5.00","$720.00",80
    "MLB","MLB $5 50/50 [Top 50% Win]","2014-05-24 19:15:00",40,93.3,"$9.00","$0.00",84,"$5.00","$450.00",50
    "MLB","MLB $5 50/50 [Top 50% Win]","2014-05-24 19:15:00",38,96.15,"$9.00","$0.00",85,"$5.00","$450.00",50
    "MLB","MLB $5.5K Moon Shot [$5,500 Guaranteed] (1/50)","2014-05-24 19:15:00",2070,68.3,"$0.00","$0.00",2434,"$2.00","$5,500.00",650
    "MLB","MLB $5.5K Moon Shot [$5,500 Guaranteed] (2/50)","2014-05-24 19:15:00",1042,93.3,"$0.00","$0.00",2434,"$2.00","$5,500.00",650
    "MLB","MLB $5.5K Moon Shot [$5,500 Guaranteed] (3/50)","2014-05-24 19:15:00",922,96.15,"$0.00","$0.00",2434,"$2.00","$5,500.00",650
    "MLB","MLB $2 Head-to-Head vs. yudarvish","2014-05-24 19:15:00",1,68.3,"$3.60","$0.00",2,"$2.00","$3.60",1
    "MLB","MLB $2 Head-to-Head vs. yudarvish","2014-05-24 19:15:00",2,68.3,"$0.00","$0.00",2,"$2.00","$3.60",1
    eos

    file1 = Tempfile.new('draftkings_file1.csv')
    file1.write(@csv_1)
    file1.rewind

    file2 = Tempfile.new('draftkings_file2.csv')
    file2.write(@csv_2)
    file2.rewind

    user = User.new(email: "test@example.com", password: "password")
  end

  def test_user_creation
    assert_equal 1, User.all.count
  end


end
