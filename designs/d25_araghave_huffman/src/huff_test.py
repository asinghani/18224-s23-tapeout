#Reference: 
#source : Geeks for geek/Internet(some piece of code)
# A Huffman Encoder - GOLDEN MODEL
import heapq


class node:
	def __init__(self, freq, symbol, left=None, right=None):
		# frequency of symbol
		self.freq = freq

		# symbol name (character)
		self.symbol = symbol

		# node left of current node
		self.left = left

		# node right of current node
		self.right = right

		# tree direction (0/1)
		self.huff = ''

	def __lt__(self, nxt):
		if self.freq == nxt.freq:
			return self.symbol < nxt.symbol
		return self.freq < nxt.freq



# creating Huffman tree
def printNodes(node, val=''):

	# huffman code for current node
	newVal = val + str(node.huff)
	#node_values = {}

	# if node is not an edge node
	# then traverse inside it
	if(node.left):
		printNodes(node.left, newVal)
	if(node.right):
		printNodes(node.right, newVal)

		# if node is edge node then
		# display its huffman code
	if(not node.left and not node.right):
		char_b = bin(ord(node.symbol))
		char_b = '00010'+char_b[2:]

		mask_length = len(newVal)
		mask = bin((1<<mask_length) - 1)
		mask = mask[2:]
		char_len = 3
		char_len1 = '{'+'0:0{}b'.format(char_len)+'}' 
		final_mask = char_len1.format(int(mask,2))
		final_val = char_len1.format(int(newVal,2))

		val = '000100'+final_mask+final_val
		node_values.setdefault(node.symbol, []).append(char_b)
		node_values[node.symbol].extend([val])

node_values= {}
output_file = open('expected_out.txt', 'w')

vector_num = 0
#can only input characters between a and 0 (hex61 to hex6F)
#string = "anm"  #read from a input vector
with open('input_vector.txt', 'r') as f:
	for line in f:
		node_values.clear()
		vector_num +=1
		freq = line.strip().split(',')
		freq = [int(value) for value in freq]
		string = next(f).strip()
		chars = list(string)
		

# list containing unused nodes
		nodes = []

# converting characters and frequencies
# into huffman tree nodes
		for x in range(len(chars)):
			heapq.heappush(nodes, node(freq[x], chars[x]))

		while len(nodes) > 1:

	# sort all the nodes in ascending order
	# based on their frequency and in case of tie, sort using ascii value
			left = heapq.heappop(nodes)
			right = heapq.heappop(nodes)

	# assign directional value to these nodes
			left.huff = 0
			right.huff = 1

	# combine the 2 smallest nodes to create
	# new node as their parent
			newNode = node(left.freq+right.freq, left.symbol+right.symbol, left, right)
			heapq.heappush(nodes, newNode)

		#use for loop to print to output 

		printNodes(nodes[0])
		#use for loop to print to output 
		for c in chars:
			if c in node_values:
				print(node_values[c][0], file=output_file)
				print(node_values[c][1], file=output_file)
		
		print("\n", file=output_file)
	

		

		
