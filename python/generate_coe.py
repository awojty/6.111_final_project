from hardcoded_nonograms import *
import pprint 
#dimensiosn are idnexed by index
#col asn row assingemtns are idnexed by address
coe_hdr = '''memory_initialization_radix=2;
memory_initialization_vector=
'''

#change to 800 for a default

nonogram_max_column = 10
nonogram_max_row = 10

#size of the entry fore the colum assingemtn for ht estorign of numebrs in the binary 
nonogram_entry_size =  800 #2*8 bit number (2x2 nonogram), change to 800 for a default
dimensions_entry_size= 8 #number of bits for one dimension i nthe fimensison field (so size of the whole field is 2* this)

def generate_coe(nonograms):
    #passes a list of abstraction of nonograms as the input
    #saves all of the to teh same coe (returns 2 coes for dimensions and actual abstraction)
    #"{0:b}".format(37)

    dimensions = [el[0] for el in nonograms]
    
    addresses = []
    row_assignments = []
    col_assignments = []
    assignments = []

    address = 0
    total_row = 0
    total_col = 0
    address_row = 0
    address_col = 0

    for d in range(len(dimensions)):
        addresses.append(format(address, '#034b')[2:])
        total_row+=dimensions[d][0]
        total_col+=dimensions[d][1]
        address += dimensions[d][0]+dimensions[d][1]
        address_col += dimensions[d][0]
        address_row += dimensions[d][1]

    print("dimensiosn", dimensions)
    print("addersses", addresses)

    input_dimensions = ["0"*16 for el in range(len(nonograms))]

    print("input", input_dimensions)
    for i,d in enumerate(dimensions):
        

        input_dimensions[i] = produce_given_length(str(format(d[0], '#08b'))[2:],dimensions_entry_size)  + produce_given_length(str(format(d[1], '#08b'))[2:],dimensions_entry_size)
        print(input_dimensions[i])

    print(input_dimensions)


    #who cares about efficiceny - lets go two for loops for readability <3
    for i,n in enumerate(nonograms):
        print("create")
        rows = n[1]  #get row assingemtns for a given nonogram
        cols = n[2]  #get col assingemtns for a given nonogram
        print(rows,cols)
        a = []
        r_as = []
        c_as = []
        for row in rows:
            #print("row", row)
            el1 = [format(r, '#010b')[2:] for r in row]
            #print("el", el)
            #print([format(r, '#010b')[2:] for r in row])

            el1 = produce_given_length("".join(el1),nonogram_entry_size)
            row_assignments.append(el1)
            r_as.append(el1)


        for col in cols:
            
            el2 = [format(c, '#010b')[2:] for c in col]
           # print("el", el)

            el2 = produce_given_length("".join(el2),nonogram_entry_size)
            col_assignments.append(el2)
            c_as.append(el2)
        assignments += r_as+ c_as #all_rows + all_columns
    print(col_assignments, len(col_assignments))
    print(row_assignments, len(row_assignments))
    print(assignments, len(assignments))

    with open("nonogram_dimensions.coe", "w") as f:
        f.write(coe_hdr)
        for el in input_dimensions:
            f.write( el + ",\n")
        f.close()

    with open("nonogram_address.coe", "w") as f:

        f.write(coe_hdr)
        print("add", addresses)
        for el in addresses:
            print("el", el)
            if el ==0:
                print("ZEEEEEEEEEEEEERO")
                
                f.write( format(0, '#034b') + ",\n")
            else:
                f.write( el + ",\n")


        

        
    with open("nonogram_assignments.coe", "w") as f:
        f.write(coe_hdr)
        for row in assignments:
            f.write(row+ ",\n")
        f.close()
        

    with open("nonogram_assignment_rows.coe", "w") as f:
        f.write(coe_hdr)
        
        for row in row_assignments:
            f.write(row+ ",\n")
        f.close()
    with open("nonogram_assignment_columns.coe", "w") as f:
        f.write(coe_hdr)
        for col in col_assignments:
            f.write(col+ ",\n")
        f.close()

def visualize_nonogram(nonogram):
    pass

def produce_given_length(string,length):
    if len(string) == length:
        return string
    else:
        print(len(string))
        difference = length - len(string)
        print("difference", difference)
        add_on = "0"*difference
        return add_on + string


def decode_nonogram(index):
    with open("nonogram_address.coe", "r") as f:
        lines = f.readlines()
        addresses = lines[2:] #remove the radix header
    with open("nonogram_dimensions.coe", "r") as f:
        dimensions = f.readlines()
        dimensions = dimensions[2:] #remove the radix header
    print("ad", addresses)
    print("dims", dimensions)

    
    address = int(addresses[index][:-2],2)
    print("Address", address)

    dimension = dimensions[index].strip().strip(",")
    size1 = int(dimension[0:8],2)
    size2 = int(dimension[8:],2)

    start_index_row = address

    end_index_row = address + size1 -1



    start_index_column = end_index_row +1
    end_index_column = start_index_column + size2 -1

    col_assignments = []
    row_assignments = []

    with open("nonogram_assignments.coe", "r") as f:
        lines = f.readlines()
        lines = lines[2:] #remove the radix header
        counter = 0
        for line in lines:
            if counter >= start_index_row and counter <= end_index_row:
                #print("row")
                
                l = len(line)
                

                items = l//8 #number of elements stored in the entr, this cna be hardcoded but no, divide by 8 since eahc number is encode by 8 bit numebr (due to 200 limit)
                rows = [line[i*8:(i+1)*8] for i in range(items)]
                
                row_assignments.append([int(r,2) for r in rows])

            elif counter >=  start_index_column and counter <= end_index_column:
                #print("col")
               
                l = len(line)
                

                items = l//8 #number of elements stored in the entr, this cna be hardcoded but no, divide by 8 since eahc number is encode by 8 bit numebr (due to 200 limit)
                cols = [line[i*8:(i+1)*8] for i in range(items)]
                
                col_assignments.append([int(r,2) for r in cols])
            elif counter == end_index_column +1:
                break
            counter+=1
        f.close()

    # with open("nonogram_assignment_rows.coe", "r") as f:
    #     lines = f.readlines()
    #     lines = lines[2:] #remove the radix header

    #     print("len", len(lines))
    #     counter = 0
    #     for line in lines:
    #         if counter >= start_index_row and counter < end_index_row:
    #             print("blobo", counter)
    #             l = len(line)
    #             print("line", line)

    #             items = l//8 #number of elements stored in the entr, this cna be hardcoded but no, divide by 8 since eahc number is encode by 8 bit numebr (due to 200 limit)
    #             rows = [line[i*8:(i+1)*8] for i in range(items)]
    #             print("ores", rows)
    #             row_assignments.append([int(r,2) for r in rows])

    #         elif counter == end_index_row+1:
    #             break
    #         counter+=1

    # with open("nonogram_assignment_columns.coe", "r") as f:
    #     lines = f.readlines()
    #     lines = lines[2:] #remove the radix header
    #     counter = 0
    #     for line in lines:
    #         if counter >= start_index_row and counter < end_index_row:
    #             l = len(line)
                
    #             items = l//8 #number of elements stored in the entr, this cna be hardcoded but no, divide by 8 since eahc number is encode by 8 bit numebr (due to 200 limit)
    #             rows = [line[i*8:(i+1)*8] for i in range(items)]
    #             print("ores", rows)
    #             row_assignments.append([int(r,2) for r in rows])

    #         elif counter == end_index_row+1:
    #             break
    #         counter+=1
    print("row", row_assignments)
    print("col", col_assignments)





if __name__ == "__main__":
    nonograms = [nonogram_music_note]
    a = generate_coe(nonograms)
    #decode_nonogram(1)
    
    # return_nonogram(1)
    


