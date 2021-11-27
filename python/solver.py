from functools import reduce

"""

question about indexing with input vairabels to verilog or register valeus doe sit work ? 


"""
 
def gen_row(w, s):
    """Create all patterns of a row or col that match given runs."""
    def gen_seg(o, sp):
        print("o", o)
        if not o:
            return [[2] * sp]
        return [[2] * x + o[0] + tail
                for x in range(1, sp - len(o) + 2)
                for tail in gen_seg(o[1:], sp - x)]

    a = [x[1:] for x in gen_seg([[1] * i for i in s], w + 1 - sum(s))]

    print("hello", a)
 
    return a

# 2010101  2 to fill 3 breaks > 002 020 202 011 101 011
"""
200 > gen pemutations (only one doff)
110 > gen permutation (only one diff >>easy to fin )


"""
# 1010101  3 to fill 3 breaks > 002 020 202 011 101 011

"""
300 > gen pemutations (only one doff)
210 > all diff (gen permuations)
201

"""

def my_gen_rows(length, setting):
    address = {i:0 for i in range(400)}
    start = [2]*length
    print("satrt", start)
    n_settings = len(setting)
    min_len = sum(setting) + n_settings - 1
    ans = []
    print("set",setting)
    if min_len == length:
        #works - once i get the puzzle, run through all the possbiel combiantins,
        counter = 0
        for s in setting:
            print("s",s)

            for i in range(counter, s+counter):
                start[i] = 1

            
            counter = counter + s+1 #give a sapce break
        print("blob")
        print(start)
        return [start]
    elif len(setting) == 1:
        #works
        start = [2]*setting[0] + [1]*(length - setting[0])
        limit = length - setting[0]
        offset = 0
        while limit >=0:
            print(len([2]*limit + [1]*setting[0] +[2]*offset))
            ans.append([2]*limit + [1]*setting[0] +[2]*offset )
            # print("asn", ans)
            offset +=1
            limit -=1

    else:
        #allcoation with single space
        #alcoation with 1 and 2 and 1 and 1 ect
        #alcoation with 1 and 1 and 2 and 1 ect
        n_settings = len(setting) #for 10 by 10 max is 5
        min_len = sum(setting) + n_settings - 1

        space_left = length - min_len
        breaks = n_settings
        ans = []

        # stack = [[1]*breaks]
        # while stack:
        #     ans.append(stack.pop())

        counter = 0
        
        for s in setting:
            
            for i in range(counter, s+counter):
                start[i] = 1
            print(start)
            
            counter = counter + s+1 #give a sapce break
        
        ans.append(start)
    
        limit = length - min_len
        offset = 0
        element = start[:min_len]
        while limit >=0:
            
            ans.append([2]*limit +  element +[2]*offset )
            offset +=1
            limit -=1

        shifts_applied = 1
        shift = 1
        min_len = sum(setting) + n_settings - 1

        for l in range(n_settings):
            shift = 1
            


            while min_len <=length:
                counter = 0
                start = [2] * length
                
            
                for i,s in enumerate(setting):
                    #well technicall yit works for 17 loops so not too bad ? 
                    #1001000101 111,222,112 211,121 221 122 212 311 131 113 123 132 321 312 213 132 (actually we dont have to acocutn for the last space)
                    

                    for j in range(counter, s+counter):
                        start[j] = 1

                    if i == l:
                        counter = counter + s+shift #give a sapce break

                    else:
                        counter = counter + s+1 #give a sapce break
                

                element = start[:min_len]
               

                limit = length - min_len
                offset = 0

                while limit >=0:
                    ans.append([2]*limit +   element +[2]*offset )
                    offset +=1
                    limit -=1

                shift = shift+1
                min_len = sum(setting) + (n_settings) + shift-1 - 1

    print("a",len(ans))
    print(len(set(map(lambda x: tuple(x), ans))))

    print("ans", ans)
    return ans



10101
#brute foerce all teh pemrutaions for space 3 for a given number left
#000
#1 > 100 010 001
#2 > 200 020 002 110 101 011
#3 > 200 020 002 110 101 011
#4 > 200 020 002 110 101 011
#5 > 200 020 002 110 101 011
#6 > 200 020 002 110 101 011
#no need to do more for 10 by 10 

# i guess we can brute force all the permutations of the spaces allocation inthe worst case scnarion fro 10 by 10 we need to generate101010101
#you need to encode each filling of the grad as tow bit sicne we need to accomodate 1,2,3 numbers

        


 
from functools import reduce
 
def gen_row(w, s):
    """Create all patterns of a row or col that match given runs."""
    def gen_seg(o, sp):
        if not o:
            return [[2] * sp]
        return [[2] * x + o[0] + tail
                for x in range(1, sp - len(o) + 2)
                for tail in gen_seg(o[1:], sp - x)]
 
    return [x[1:] for x in gen_seg([[1] * i for i in s], w + 1 - sum(s))]
 



def deduce(hr, vr):
    """Fix inevitable value of cells, and propagate."""
    def allowable(row):
        print("row", row)
        return reduce(lambda a, b: [x | y for x, y in zip(a, b)], row)
 
    def fits(a, b):
        # print("ab",a,b)
        
        # print("zipab", list(zip(a, b)))
        # print("res", [x & y for x, y in zip(a, b)])
        # print("ans", all(x & y for x, y in zip(a, b)))
        return all(x & y for x, y in zip(a, b))
 
    def fix_col(n):
        """See if any value in a given column is fixed;
        if so, mark its corresponding row for future fixup.

        we are adding stuff to mod_row
        which are then used ni fix_col

        use a n array to mark wih 1 the indexes which were addded to fix_col > you can get theri count by just summing 
        
        """

        # print("n", n)
        # print("cando", can_do) [8, 28, 15, 21, 5, 10, 5, 10, 9, 1]
        

        c = []

        for i in range(len(can_do)):
            c.append(can_do[i][n])
        #     print("elelemntn", can_do[i][n])
        # print("nc",n, c, len(c))

        # c = [x[n] for x in can_do]
        # print("c2",c)
        # cols[n] = [x for x in cols[n] if fits(x, c)] 
        # 12000

        results = []
        indexes_included = []

        for index,x in enumerate(cols[n]):
            if fits(x, c):
                indexes_included.append(index)
                results.append(x)

                
                
                
                
        # print("resutls,", len(results), results)
        cols[n] = results

        allowed_things = allowable(results)
        
        # print("allowed, linths",allowed_things)
        
        # print("candohere", can_do, len(can_do))# it alwasy has length 9 
        
        

        for i, x in enumerate(allowed_things):
            if x != can_do[i][n]:
                #mod_rows.add(i) 11 01 > 01
                # print("can_do[i][n]", can_do[i][n])
                # print("x", x)
                
                mod_rows_in[i] = 1
                can_do[i][n] &= x
                # print("can_do[i][n]", can_do[i][n])
                
        print("cando after", can_do[n])


                
 
    def fix_row(n):
        """Ditto, for rows."""
        c = can_do[n]
        #print("B", rows[n]) #get all possible states of row at index n in the puzzle
        rows[n] = [x for x in rows[n] if fits(x, c)]
        for i, x in enumerate(allowable(rows[n])):
            if x != can_do[n][i]:
                mod_cols_in[i] = 1
                #mod_cols.add(i) #at index i of array mod_cols, set it to 1
                can_do[n][i] &= x
                
                
    def get_bin(x):
        """
        Get the binary representation of x.

        Parameters
        ----------
        x : int
        n : int
            Minimum number of digits. If x needs less digits in binary, the rest
            is filled with zeros.

        Returns
        -------
        str
        """
        return format(x, 'b').zfill(2)
 
    def show_gram(m):
        # If there's 'x', something is wrong.
        # If there's '?', needs more work.
        
        print("m", m )
        for x in m:
            row = "".join(list(map(get_bin, x)))
            # print(len(row))
            
            # decimal_representation = int(row, 2)
            # hexadecimal_string = hex(decimal_representation)
            # #print(row)
            # print(hexadecimal_string)
            print(" ".join("x#.?"[i] for i in x))
        print()
 
    w, h = len(vr), len(hr)
    #bram for rows and cols - 2000 entries (10^2*(10+10)) and 20(10 len*2 bits) width
    # bram for number allocations 20 col+rows 5 numbers above a given row/col 10 is the biggest (4bits)
    # 20 entries per nanogram 5*4 = 20
    # for a given nonogram you need 5*4*20 = 400 bits 
    #ps2 mouse
    #eithe tnumebr recognition or 2 bit image to the nonogram

    # rows = [my_gen_rows(w, x) for x in hr]
    # cols = [my_gen_rows(h, x) for x in vr]
    rows = [gen_row(w, x) for x in hr] 
    cols = [gen_row(h, x) for x in vr] 
    
    # print("rwos", rows)
    # print("cols", cols)
    
    """
    length [8, 28, 15, 21, 5, 10, 5, 10, 9, 11]
    length col [28, 21, 10, 3, 6, 8, 7, 8, 11, 11]
    lengthsum 122
    lengthsum-col 113
    
    """
    
    print("lastlow", rows[-2])
    
    print("length", list(map(len, rows)))
    print("length col", list(map(len, cols)))
    print("lengthsum", sum(list(map(len, rows))))
    print("lengthsum-col", sum(list(map(len, cols))))
    
    rows_len = []
    

    can_do= []
    
    can_d_hex = []

    for i,r in enumerate(rows):
        r_new = [tuple(x) for x in r]
        # print("r_new", r_new)
        # print()
        
        # print("rnewset", set(r_new))
        # print("idnex", i)
        # print("len",len(r_new))
        
        for el in r:
            print(el)

            
        
       
        rows_len.append(len(list(set(r_new))))
        #print("allwable(r)", allowable(r))
        
        allowabler = allowable(r)
        ans = ""
        for i in allowabler:
            f = '{0:02b}'.format(i)
            print("3f", f)
            ans+=f
        print("ans", ans)
        can_d_hex.append(hex(int("0b" +(str(ans)),2)))
        can_do.append(allowable(r))
        
    print("1candohexs", can_do)
    print(can_d_hex)
    """
    ['0xfffff', 
    '0xfffff', 
    '0xfffff', 
    '0xfffff', 
    '0x3ffff', 
    '0x3ffff', 
    '0x3ffff',// 
    '0xfffff', 
    '0xfffff', 
    '0xaaaaa']
    [[3, 3, 3, 3, 3, 3, 3, 3, 3, 3], 
    [3, 3, 3, 3, 3, 3, 3, 3, 3, 3], 
    [3, 3, 3, 3, 3, 3, 3, 3, 3, 3], 
    [3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
    [3, 3, 3, 3, 1, 1, 3, 3, 3, 3], 
    [3, 3, 3, 3, 3, 1, 1, 3, 3, 3], 
    [3, 3, 3, 3, 1, 1, 3, 3, 3, 3], //inverted 01 here > 01 in untitled
    [3, 3, 3, 3, 3, 3, 3, 3, 3, 3], 
    [3, 3, 3, 3, 3, 3, 3, 3, 3, 3],
    [2, 2, 2, 2, 2, 2, 2, 2, 2, 2]]
    
    """
    
    
    # print("lenght of permituaiont", rows_len)
    # print("titla_count", sum(rows_len))
        
    # print("past allowable can do")
    
    
#     lenght of permituaiont [8, 28, 15, 21, 5, 10, 5, 10, 9, 11]
# titla_count 122
# past allowable can do
        
   # print("lenf cado", len(can_do), can_do, len(rows))
    
 
    # Initially mark all columns for update.
    mod_rows, mod_cols = set(), set(range(w))

    mod_rows_in = [0]*h

    mod_cols_in = [1]*w
    
    counter = 0

    while sum(mod_cols_in) >0:
        counter+=1
        for i in range(w):
            if mod_cols_in[i]:
                fix_col(i)
        mod_cols_in = [0] * w
        
        print("oteration mod rows in", mod_rows_in, counter)
        for j in range(h):
            if mod_rows_in[j]:
                fix_row(j)
        mod_rows_in = [0] * h
    print("coutner", counter)


 
    # while mod_cols:
    #     for i in mod_cols:
    #     #go through the mod_colls 0/1 array and get the indexeds that are actually 1 which will hen server as the range(or rahter oteration) for i 
    #         fix_col(i)
    #     mod_cols = set() #sero all the thinfs in the array
    #     for i in mod_rows:
    #         fix_row(i)
    #     mod_rows = set()
 
    if all(can_do[i][j] in (1, 2) for j in range(w) for i in range(h)):
        print("Solution would be unique")  # but could be incorrect!
    else:
        print("Solution may not be unique, doing exhaustive search:")

    print()
    print("AAAAAAAAAAAA")
    show_gram(can_do)
 
    # We actually do exhaustive search anyway. Unique solution takes
    # no time in this phase anyway, but just in case there's no
    # solution (could happen?).
    out = [0] * h
 
    def try_all(n = 0):
        if n >= h:
            for j in range(w):
                if [x[j] for x in out] not in cols[j]:
                    return 0
            show_gram(out)
            return 1
        sol = 0
        for x in rows[n]:
            out[n] = x
            sol += try_all(n + 1)
        return sol
 
    # n = try_all()
    # if not n:
    #     print("No solution.")
    # elif n == 1:
    #     print("Unique solution.")
    # else:
    #     print(n, "solutions.")
    # print()
 
 
def solve(s, show_runs=True):
   
    print("Horizontal runs:", s[0])
    print("Vertical runs:", s[1])
    
    #deduce(ho,ve)
    

    
    deduce(s[0],s[1])
   
    # deduce(
    #     [[3], [2, 1], [3, 2], [2, 2], [6], [1, 5], [6], [1], [2]], 
    #        [[1, 2], [3, 1], [1, 5], [7, 1], [5], [3], [4], [3]])


ho = [[2]]
ve=  [[1],[1]]

l1 = [[3],[2,1],[2,3],[1,2,1],[2,1],[1,1],[1,3],[3,4],[4,4],[4,2]]
    
l2 = [
        [2],
        [4],
        [4],
        [8],
        [1,1],
        [1,1],
        [1,1,2],
        [1,1,4],
        [1,1,4],
        [9]
    ]


b1 =[[0],[3],[3],[3],[0]]
b2 =[[0],[3],[3],[3],[0]]

d1 =[[3], [1,2], [2,3], [2, 2], [6], [5,1], [6], [1], [2], [0]]
d2 =   [[2,1], [1,3], [ 5,1], [ 1,7], [5], [3], [4], [3], [0], [0]]

a1 =  [[3], [2, 1], [3, 2], [2, 2], [6], [1, 5], [6], [1], [2], [0]] #row constraitns - left to righ 

a2 =  [[1, 2], [3, 1], [1, 5], [7, 1], [5], [3], [4], [3], [0], [0]] #column constraints

solve([a1,a2])


##use this code to generate teh numbers n ipytohn and just store them in registr"
aaa = []
def subset_sum(numbers, target, partial=[]):
    s = sum(partial)

    # check if the partial sum is equals to target
    if s == target: 
        print("sum(%s)=%s" % (partial, target))
        aaa.append(partial)
    if s >= target:
        return  # if we reach the number why bother to continue
    
    for i in range(len(numbers)):
        n = numbers[i]
        remaining = numbers[i+1:]
        subset_sum(remaining, target, partial + [n]) 
   

# Python 3 program to print all
# possible strings of length k
     
# The method that prints all
# possible strings of length k.
# It is mainly a wrapper over
# recursive function printAllKLengthRec()
def printAllKLength(set, k):
 
    n = len(set)
    printAllKLengthRec(set, "", n, k)
 
# The main recursive method
# to print all possible
# strings of length k
def printAllKLengthRec(set, prefix, n, k):
     
    # Base case: k is 0,
    # print prefix
    if (k == 0) :
        print(prefix)
        return
 
    # One by one add all characters
    # from set and recursively
    # call for k equals to k-1
    for i in range(n):
 
        # Next character of input added
        newPrefix = prefix + set[i]
         
        # k is decreased, because
        # we have added a new character
        # printAllKLengthRec(set, newPrefix, n, k - 1)
        
        #overallping from both sdies
        
		# 		int start = solv->row_runs[i][j].s;0
		# 		int end = solv->row_runs[i][j].e; 10
		# 		int u = 10 - 0 + 1 - 6; = 6

		# 		for (int k = start + u = 6 ; k <= end - u = 4  8; k++) {
		# 			int status = solu->set(i, k, p->row_constraints[i][j].color);
		# 			if (status == CONFLICT) conflict = true;
		# 			if (status == PROGRESS) progress = true;
		# 		}
  
  
s1 = "1010_0101010101010101"
     #"10010101010101010100"
     #"1010101010101010010"
s2 =  "10010101010101010110"
s3 = "01010101010101011010"

a1 = bin(int("bf7ff", 16))
print("a1",a1)
a2 = hex(int(s2, 2))
a3 = hex(int(s3, 2))

#a655 10.10.10.01.01.//10.//01.01.01.01 0  0b 10.11.11.11.01.11.11.11.11.11 2333133333

#5aa55  01.01.10.10.10.10.01.01.01.01 3
#96a55  10.01.01.//10.10.10.//01.01.01.01

#a5a55 10.10.01.01.10.10.01.01.01.01 1
a4 = bin(int("995a5", 16))[2:]

#"10./01./10/.01.01.01.//10.10.//01.01

print(a1,a2,a3, a4)
print(len(gen_row(10, [3])))


# a  = gen_row(10, [1,3,1])

# for index,el in enumerate(a):
#     a[index] = tuple(el)
    
# a = set(a)

# print(len(a))
    


