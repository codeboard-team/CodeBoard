module DockerExec
  class PythonService
    attr_reader :code, :test_code, :path, :separator, :container_id
  
    def initialize(code = "", test_code = [''])
      @code = code
      @test_code = test_code
      @path = file_path
      @separator = get_separator
    end
  
    def run
      if lack_args?
        nil
      else
        create_file
        get_id
        5.times do
          if done?
            result = get_result
            remove_file_and_container
            return result
          else
            sleep 1
          end
        end
        remove_file_and_container
        return "Times out!"
      end
    end
  
    private
    def lack_args?
      return code.empty? || test_code.nil? || test_code.map{ |e| e.empty?}.include?(true)
    end

    def create_file
      file = File.open(path, "w") 
      contents.each { |e|
        file.write(e)
        file.write("\n")
      }
      file.close
    end
  
    def get_id
      @container_id = `docker run -d -m 128M -c 512 -v #{path}:/main.py python3 python3 /main.py`
    end
  
    def done?
      `docker ps --format "{{.ID}}: {{.Status}}" -f "id=#{container_id}"`.empty?
    end

    def get_result
      raw_output = `docker logs #{container_id}`
      if raw_output.empty?
        out, err = Open3.capture3("`docker logs #{container_id}`")
        [err]
      else
        out = JSON.parse(raw_output.split("#{separator}").pop.strip)
      end
    end
  
    def remove_file_and_container
      File.unlink(path)
      `docker rm -f #{container_id}`
    end
  
    def file_path
      tmp_file = [*"a".."z", *"A".."Z"].sample(5).join('') + ".py"
      path = Rails.root.join('tmp', "#{tmp_file}").to_s
    end

    def get_separator
      [*"a".."z", *"A".."Z"].sample(10).join('')
    end
  
    def contents
      test_data = test_code.map{ |e| e = "result.append(#{e})" }.join("\n")
      [code, "import json", "result = []", test_data, "print(\"#{separator}\")", "print(json.dumps(result))"]
    end
  end
end