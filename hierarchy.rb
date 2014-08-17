# Dumps the ancestors of a class in the Graphviz format.
# Example: ruby -rsocket hierarchy.rb TCPSocket | dot -Tpng /dev/stdin > out.png

def valid_class? name
  return false if name.empty?

  get_class name
  true
rescue NameError
  false
end

def get_class name
  name.split(/::/).reduce(Object) { |a,b| a.const_get b }
end

def nil.included_modules; [] end

fail "Usage: ruby [-rLIBRARY] #{$0} CLASS" unless ARGV.size == 1

if valid_class? ARGV[0]
  klass = get_class(ARGV[0])
else
  puts 'digraph { "ERROR"->"ERROR" }'
  exit 1
end  

rels = klass.ancestors
klasses, mods = rels.partition {|m| m.is_a? Class }

puts "digraph { {"

# depict modules as boxes
mods.each do |m|
  puts "\"#{m}\" [shape=box3d]"
end

puts "}"

klasses.each do |k|
  puts "\"#{k}\"->\"#{k.superclass}\"" if k.superclass

  im = k.included_modules - k.superclass.included_modules
  im.each do |m|
    puts "\"#{k}\"->\"#{m}\""
  end
end

puts '}'
