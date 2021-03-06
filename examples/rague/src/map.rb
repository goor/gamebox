require 'polaris'
require 'two_d_grid_map'
require 'line_of_site'
require 'algorithms'
include Containers

# this is the grid map for rague
class Map < Actor
  attr_accessor :tile_width, :tile_height, :drawable_tiles
  def setup
    @tile_width = 30
    @tile_height = 30
    @drawable_tiles = Stack.new
  end
  
  def size=(s)
    @map = TwoDGridMap.new s[0], s[1]
    @los = LineOfSite.new @map
  end
  
  def update_drawable_tiles(viewport)
    
    @drawable_tiles.each do |t|
      t.hide
    end
    @drawable_tiles = Stack.new
    left = x - viewport.x_offset
    right = left + viewport.width
    top = y - viewport.y_offset
    bottom = top + viewport.height
    
    l,t = screen_to_tile left, top
    r,b = screen_to_tile right, bottom
    
    (l..r+1).each do |col|
      (t..b+1).each do |row|
        tile = @map.occupant(loc2(col,row))
        if tile
          tile.show
          @drawable_tiles.push tile
        end
      end
    end
    
  end
  
  def update_lit_locations(source_location, range=11)
    # clear visibility of tiles
    @drawable_tiles.each do |t|
      t.lit = false
    end
    
    r = ((range-1)/2).floor
    range.times do |i|
      x = source_location.x
      y = source_location.y
      @los.losline x, y, x-r+i, y-r
      @los.losline x, y, x-r+i, y+r
      @los.losline x, y, x-r, y-r+i
      @los.losline x, y, x+r, y-r+i
      @los.losline x, y, x+1, y-r+i
      @los.losline x, y, x-1, y-r+i
      @los.losline x, y, x-r+i, y-1
      @los.losline x, y, x-r+i, y+1
    end
  end
  
  def screen_to_tile(x,y)
    tiles = [(x / @tile_width).floor, (y / @tile_height).floor]
    tiles[0] = 0 if tiles[0] < 0
    tiles[0] = @map.w - 1 if tiles[0] > @map.w - 1
    tiles[1] = 0 if tiles[1] < 0
    tiles[1] = @map.h - 1 if tiles[1] > @map.h - 1
    tiles
  end
  
  def place(location, thing=nil)
    @map.place location, thing
  end
  
  def occupant(location)
    @map.occupant location
  end  
  
  def move_to(thing, location)
    new_tile = occupant location
    if thing.location
      old_tile = occupant thing.location 
      old_tile.occupants.delete thing
    end
    new_tile.occupants << thing
    thing.location = location
    
    # TODO is there a better way to keep x,y in sync with map locaiton?
    thing.x = (location.x-0.5)*@tile_width
    thing.y = (location.y-0.5)*@tile_height
  end
  
  def size
    @map.size
  end
end
