require 'rails_helper'

RSpec.describe DockerExec::PythonService do

  describe "基本功能" do

    it "符合格式的程式碼執行" do
      code = "def greeting(name) : \r\n  return \"Hello  %s\" %(name)"
      test_code = ["greeting(\"Code\")", "greeting(\"Board\")"]

      py = DockerExec::PythonService.new(code, test_code)
      py.run

      expect(py.result).to eq ["Hello  Code", "Hello  Board"]
      expect(py.fail?).to eq false
      expect(py.timeout?).to eq false
    end

    it "無窮迴圈的程式碼執行" do
      code = "def infinite_loop(count):\r\n  while count < 3:\r\n    print(count)"
      test_code = ["infinite_loop(0)"]

      py = DockerExec::PythonService.new(code, test_code)
      py.run

      expect(py.result).to be nil
      expect(py.fail?).to eq true
      expect(py.timeout?).to eq true
    end

    it "印出 STDERR 訊息" do
      code = "def greeting(name) : \r\n  return \"Hello  %s\" %(name)"
      test_code = ["greeting\"Code\"", "greeting\"Board\""]

      py = DockerExec::PythonService.new(code, test_code)
      py.run

      expect(py.result).to eq "  File \"/main.py\", line 5\n    result.append(greeting\"Code\")\n                          ^\nSyntaxError: invalid syntax\n"
      expect(py.fail?).to eq true
      expect(py.timeout?).to eq false
    end

    it "引數為 nil 的補救情況" do
      code = ""
      test_code1 = nil
      test_code2 = [""]
      test_code3 = ["", ""]

      py1 = DockerExec::PythonService.new(code, test_code1)
      py2 = DockerExec::PythonService.new(code, test_code2)
      py3 = DockerExec::PythonService.new(code, test_code3)
      py1.run
      py2.run
      py3.run

      expect(py1.result).to be nil
      expect(py2.result).to be nil
      expect(py3.result).to be nil
      expect(py1.fail?).to eq true
      expect(py2.fail?).to eq true
      expect(py3.fail?).to eq true
      expect(py1.timeout?).to eq false
      expect(py2.timeout?).to eq false
      expect(py3.timeout?).to eq false

    end

  end

end