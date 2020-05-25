require 'rails_helper'

RSpec.describe DockerExec::RubyService do

  describe "基本功能" do

    it "符合格式的程式碼執行" do
      code = "def iteration(list)\r\n  list.map do |el|\r\n    el = el + 2\r\n  end\r\nend"
      test_code = ["iteration [1, 2, 3, 4, 5]", "iteration [4, 5, 6, 7, 8]"]

      ruby = DockerExec::RubyService.new(code, test_code)

      expect(ruby.run).to eq [[3, 4, 5, 6, 7], [6, 7, 8, 9, 10]]
    end

    it "無窮迴圈的程式碼執行" do
      code = "def circle(counter)\r\n  while counter < 11 do\r\n    puts counter\r\n  end\r\nend"
      test_code = ["circle(1)"]

      ruby = DockerExec::RubyService.new(code, test_code)

      expect(ruby.run).to eq "Times out!"
    end

    it "印出 STDERR 訊息" do
      code = "def iteration(list)\r\n  day\r\nend"
      test_code = ["iteration [1, 2, 3, 4, 5]", "iteration [4, 5, 6, 7, 8]"]

      ruby = DockerExec::RubyService.new(code, test_code)

      expect(ruby.run) == 
      ["/main.rb:2:in `iteration': undefined local variable or method `day' for main:Object (NameError) from /main.rb:6:in `<main>'"]
    end

    it "引數為 nil 的補救情況" do
      code = ""
      test_code1 = nil
      test_code2 = [""]
      test_code3 = ["", ""]

      ruby1 = DockerExec::RubyService.new(code, test_code1)
      ruby2 = DockerExec::RubyService.new(code, test_code2)
      ruby3 = DockerExec::RubyService.new(code, test_code3)

      expect(ruby1.run).to be nil
      expect(ruby2.run).to be nil
      expect(ruby3.run).to be nil
    end

  end

end