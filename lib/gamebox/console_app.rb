if $0 == __FILE__
  puts "Connecting to game..."
  require 'irb'
  require 'irb/completion'
  module IRB
    def IRB.start_session(obj)
      unless $irb
        IRB.setup nil
        ## maybe set some opts here, as in parse_opts in irb/init.rb?
        IRB.load_modules
      end
    
      workspace = WorkSpace.new(obj)

      if @CONF[:SCRIPT] ## normally, set by parse_opts
        $irb = Irb.new(workspace, @CONF[:SCRIPT])
      else
        $irb = Irb.new(workspace)
      end

      @CONF[:IRB_RC].call($irb.context) if @CONF[:IRB_RC]
      @CONF[:MAIN_CONTEXT] = $irb.context

      trap("INT") do
        $irb.signal_handle
      end

      catch(:IRB_EXIT) do
        $irb.eval_input
      end
      print "\n"
    
      ## might want to reset your app's interrupt handler here
    end
  end

  require 'drb'
  DRb.start_service
  game = DRbObject.new nil, "druby://localhost:7373"
  IRB.start_session game
end