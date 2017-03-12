lxp = require 'lxp'

float = '(%-?%d+%.%d*)'

layers = {}
sx, sy = 1, 1
callbacks =
  StartElement: (parser, name, attributes) ->
    if name == 'svg' and attributes.viewBox
      vw, vh = assert attributes.viewBox\match "0 0 #{float} #{float}"
      sx = attributes.width / vw
      sy = attributes.height / vh
    elseif name == 'g'
      layer = attributes['inkscape:label'] or attributes.id
      print " #{layer} = {"
    elseif name == 'path'
      start, data = assert attributes.d\match '^([mM]) (.*)'

      lx, ly = 0, 0
      print '  {'
      for x, y in data\gmatch "#{float},#{float}"
        x = lx + sx * tonumber x
        y = ly + sy * tonumber y
        print "   #{x}, #{y},"

        if start == 'm'
          lx, ly = x, y

      print '  },'
  EndElement: (parser, name) ->
    if name == 'g'
      print ' },'

p = lxp.new callbacks

print 'return {'
p\parse io.stdin\read '*a'
p\parse!
print '}'
