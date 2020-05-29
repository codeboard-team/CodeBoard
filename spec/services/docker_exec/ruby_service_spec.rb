require 'rails_helper'

RSpec.describe DockerExec::RubyService do

  describe "基本功能" do

    it "符合格式的程式碼執行" do
      code = "def iteration(list)\r\n  list.map do |el|\r\n    el = el + 2\r\n  end\r\nend"
      test_code = ["iteration [1, 2, 3, 4, 5]", "iteration [4, 5, 6, 7, 8]"]

      ruby = DockerExec::RubyService.new(code, test_code)
      ruby.run

      expect(ruby.result).to eq [[3, 4, 5, 6, 7], [6, 7, 8, 9, 10]]
      expect(ruby.fail?).to eq false
      expect(ruby.timeout?).to eq false
    end

    it "無窮迴圈的程式碼執行" do
      code = "def circle(counter)\r\n  while counter < 11 do\r\n    puts counter\r\n  end\r\nend"
      test_code = ["circle(1)"]

      ruby = DockerExec::RubyService.new(code, test_code)
      ruby.run
      
      expect(ruby.result).to be nil
      expect(ruby.fail?).to eq true
      expect(ruby.timeout?).to eq true
    end

    it "印出 STDERR 訊息" do
      code = "def iteration(list)\r\n  day\r\nend"
      test_code = ["iteration [1, 2, 3, 4, 5]", "iteration [4, 5, 6, 7, 8]"]

      ruby = DockerExec::RubyService.new(code, test_code)
      ruby.run

      expect(ruby.result) == "/main.rb:2:in `iteration': undefined local variable or method `day' for main:Object (NameError) from /main.rb:6:in `<main>'"
      expect(ruby.fail?).to eq true
      expect(ruby.timeout?).to eq false
    end

    it "引數為 nil 的補救情況" do
      code = ""
      test_code1 = nil
      test_code2 = [""]
      test_code3 = ["", ""]

      ruby1 = DockerExec::RubyService.new(code, test_code1)
      ruby2 = DockerExec::RubyService.new(code, test_code2)
      ruby3 = DockerExec::RubyService.new(code, test_code3)
      ruby1.run
      ruby2.run
      ruby3.run

      expect(ruby1.result).to be nil
      expect(ruby2.result).to be nil
      expect(ruby3.result).to be nil
      expect(ruby1.fail?).to eq true
      expect(ruby2.fail?).to eq true
      expect(ruby3.fail?).to eq true
      expect(ruby1.timeout?).to eq false
      expect(ruby2.timeout?).to eq false
      expect(ruby3.timeout?).to eq false
    end

  end

end