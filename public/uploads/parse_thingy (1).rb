require 'nokogiri'

def display_node_name(node, depth = 0)
	0.upto(depth-1) { |i| print "\t" } if depth > 0 # indenting
	puts node.name
	sub_nodes = node.xpath("./*")
	sub_nodes.map { |n| display_node_name(n, depth+1) } if sub_nodes.length > 0
end

# lees xml bestand
f = File.open("magento.xml")
doc = Nokogiri::XML(f)
f.close

# begin bij de root-node
display_node_name(doc.xpath("./*").first)