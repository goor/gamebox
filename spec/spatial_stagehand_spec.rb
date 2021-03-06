require File.join(File.dirname(__FILE__),'helper')

describe 'a new SpacialStagehand' do
  before do
    @target = SpatialStagehand.new :stage, {}
    @hash = @target.instance_variable_get("@spatial_actors")
  end

  describe "it constructs" do
    it 'should be constructable with default params' do
      @target.cell_size.should == 50
    end

    it 'passes on cell_size' do
      @target = SpatialStagehand.new :stage, {:cell_size => 99}
      @target.cell_size.should == 99
    end
  end
  
  describe "#cell_size" do
    it "returns the cell size" do
      @hash.cell_size = :size
      @target.cell_size.should == :size
    end
    it "sets the cell size" do
      @target.cell_size = :size
      @hash.cell_size.should == :size
    end
  end

  describe "#auto_resize" do
    it "returns the resize setting" do
      @hash.auto_resize = :resize
      @target.auto_resize.should == :resize
    end

    it "sets the resize setting" do
      @target.auto_resize = :resize
      @hash.auto_resize.should == :resize
    end
  end

  describe "#items" do
    it "returns all the items" do
      @hash.instance_variable_set("@items", :items)
      @target.items.should == :items
    end
  end

  describe "#buckets" do
    it "returns all the buckets" do
      @hash.instance_variable_set("@buckets", :buckets)
      @target.buckets.should == :buckets
    end
  end

  describe "#add" do
    it 'should add the actor to the hash' do
      @actor = stub(:when)
      @hash.expects(:add).with(@actor)
      @target.add(@actor)
    end

    it 'should register for remove_me event' do
      @actor = Actor.new {}
      @target.add(@actor)

      @hash.expects(:remove).with(@actor)

      @actor.send :fire, :remove_me
    end

    it 'should register for x_changed event' do
      @actor = Actor.new {}
      @target.add(@actor)

      @hash.expects(:remove).with(@actor)
      @hash.expects(:add).with(@actor)

      @actor.send :fire, :x_changed
    end

    it 'should register for y_changed event' do
      @actor = Actor.new {}
      @target.add(@actor)

      @hash.expects(:remove).with(@actor)
      @hash.expects(:add).with(@actor)

      @actor.send :fire, :y_changed
    end
  end

  describe "#remove" do
    it "removes the actor from the hash" do
      @hash.expects(:remove).with(:actor)
      @target.remove(:actor)
    end
  end

  describe "#items_at" do
    it "calls through to hash" do
      @hash.expects(:items_at).with(:x, :y)
      @target.items_at(:x,:y)
    end
  end
  describe "#items_in" do
    it "calls through to hash" do
      @hash.expects(:items_in).with(:x, :y, :w, :h)
      @target.items_in(:x,:y, :w, :h)
    end
  end
  describe "#neighbors_of" do
    it "calls through to hash" do
      @hash.expects(:neighbors_of).with(:actor, 3)
      @target.neighbors_of(:actor, 3)
    end
  end
end
