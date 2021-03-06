

class GraphicalActorView < ActorView
  def draw(target, x_off, y_off, z)
    x = actor.x
    y = actor.y

    offset_x = x+x_off
    offset_y = y+y_off

    img = actor.image
    return if img.nil?

    scale = actor.respond_to?(:scale) ? actor.scale : 1
    alpha = actor.respond_to?(:alpha) ? actor.alpha : 0xFF

    if actor.is? :physical
      img_w = img.width
      img_h = img.height

      img.draw_rot offset_x, offset_y, z, actor.rotation, 0.5, 0.5, scale, scale
    else
      graphical_behavior = actor.graphical if actor.is? :graphical
      if graphical_behavior && graphical_behavior.tiled?
        x_tiles = graphical_behavior.num_x_tiles
        y_tiles = graphical_behavior.num_y_tiles
        img_w = img.width
        img_h = img.height
        x_tiles.times do |col|
          y_tiles.times do |row|
            img.draw_rot offset_x+col*img_w, offset_y+row*img_h, z, actor.rotation, scale, scale
          end
        end
      else
        if actor.respond_to? :rotation
          rot = actor.rotation || 0.0
          img.draw_rot offset_x, offset_y, z, rot, 0.5, 0.5, scale, scale, Color.new(alpha,0xFF,0xFF,0xFF)
        else
          img.draw offset_x, offset_y, z, scale, scale, Color.new(alpha,0xFF,0xFF,0xFF)
        end
      end
    end
  end
end
