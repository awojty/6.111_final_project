from functools import reduce

"""

question about indexing with input vairabels to verilog or register valeus doe sit work ? 


"""
 
def gen_row(w, s):
    """Create all patterns of a row or col that match given runs."""
    def gen_seg(o, sp):
        
        if not o:
            return [[2] * sp]
        return [[2] * x + o[0] + tail
                for x in range(1, sp - len(o) + 2)
                for tail in gen_seg(o[1:], sp - x)]

    a = [x[1:] for x in gen_seg([[1] * i for i in s], w + 1 - sum(s))]

    
 
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
        
        return [start]
    elif len(setting) == 1:
        #works
        start = [2]*setting[0] + [1]*(length - setting[0])
        limit = length - setting[0]
        offset = 0
        while limit >=0:
           
            ans.append([2]*limit + [1]*setting[0] +[2]*offset )
            
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
        
        return reduce(lambda a, b: [x | y for x, y in zip(a, b)], row)
 
    def fits(a, b):
        
        # print("a",a)
        # print("b",b)
        # print(all(x & y for x, y in zip(a, b)))
        # print(zip(a,b))
        #print([x & y for x, y in zip(a, b)])

        return all(x & y for x, y in zip(a, b))
 
    def fix_col(n, iteration = 0):
        """See if any value in a given column is fixed;
        if so, mark its corresponding row for future fixup.

        we are adding stuff to mod_row
        which are then used ni fix_col

        use a n array to mark wih 1 the indexes which were addded to fix_col > you can get theri count by just summing 
        
        """



        c = []

        for i in range(len(can_do)):
            # print("_________________________________")
            # print("in", i, n)
            # print("can_do[i]",can_do[i])
            # print("can_do[i][n",can_do[i][n])
            c.append(can_do[i][n])
        # print("_)))))))))))))))))))))))))))))))))___")
            
        # print("2c-array", iteration, c, len(c))
        
        print(can_do)
        

        results = []
        indexes_included = []

        for index,x in enumerate(cols[n]):
            if fits(x, c):
                results.append(x)
                indexes_included.append(index)
        #print("indexes_included, iteration, n ", indexes_included, iteration, n)
                
                
        # print("resutls,", len(results), results)
        cols[n] = results

        allowed_things = allowable(results)
        
        print("cando before", can_do[n], iteration)
        

        for i, x in enumerate(allowed_things):
            if x != can_do[i][n]:
                #mod_rows.add(i) 11 01 > 01
                # print("can_do[i][n]", can_do[i][n])
                # print("x", x)
                
                mod_rows_in[i] = 1
                can_do[i][n] &= x
                # print("can_do[i][n]", can_do[i][n])
        print("cando after", can_do[n], iteration)

                
 
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

    # rows = [my_gen_rows(w, x) for x in hr]
    # cols = [my_gen_rows(h, x) for x in vr]
    rows = [gen_row(w, x) for x in hr] 
    cols = [gen_row(h, x) for x in vr] 
    
    print("HAHHHHHHHHHH", len(gen_row(10,[0])))
    
  
    
    
    
  
    
    rows_len = []
    

    can_do= []
    
    can_d_hex = []
    
    def turn_into_hex(row):
        #print("row", row)
        a = []
        
        for i,r in enumerate(row):

            ans = ""
            for j in r:
                f = '{0:02b}'.format(j)
                
                ans+=f
            a.append(hex(int("0b" +(str(ans)),2)))
            
        return a
    
    def turn_into_hex1(row):
            #print("row", row)
        a = []
        ans = ""
        print(row)
        
        for i,r in enumerate(row):

            
            
            f = '{0:02b}'.format(r)
                
            ans+=f[2:]
            
        print(ans)
            
            
        return hex(int("0b" +(str(ans)),2))
    

    """
    
    hexrows [
        ['0x56aaa', '0x95aaa', '0xa56aa', '0xa95aa', '0xaa56a', '0xaa95a', '0xaaa56', '0xaaa95'],
        
        ['0x59aaa', '0x5a6aa', '0x5a9aa', '0x5aa6a', '0x5aa9a', '0x5aaa6', '0x5aaa9', '0x966aa', 
        '0x969aa', '0x96a6a', '0x96a9a', '0x96aa6', '0x96aa9', '0xa59aa', '0xa5a6a', '0xa5a9a', 
        '0xa5aa6', '0xa5aa9', '0xa966a', '0xa969a', '0xa96a6', '0xa96a9', '0xaa59a', '0xaa5a6', 
        '0xaa5a9', '0xaa966', '0xaa969', '0xaaa59'],
        
        ['0x565aa', '0x5696a', '0x56a5a', '0x56a96', '0x56aa5', '0x9596a', '0x95a5a', '0x95a96', '0x95aa5',
        '0xa565a', '0xa5696', '0xa56a5', '0xa9596', '0xa95a5', '0xaa565'], 
        
        ['0x596aa', '0x5a5aa', '0x5a96a', '0x5aa5a', '0x5aa96', '0x5aaa5', 
        '0x965aa', '0x9696a', '0x96a5a', '0x96a96', '0x96aa5', '0xa596a', 
        '0xa5a5a', '0xa5a96', '0xa5aa5', '0xa965a', '0xa9696', 
        '0xa96a5', '0xaa596', '0xaa5a5', '0xaa965'], 
        
        ['0x555aa', '0x9556a', '0xa555a', '0xa9556', '0xaa555'],
        
        ['0x6556a', '0x6955a', '0x6a556', '0x6a955', '0x9955a', '0x9a556',
        '0x9a955', '0xa6556', '0xa6955', '0xa9955'],
        
        ['0x555aa', '0x9556a', '0xa555a', '0xa9556', '0xaa555'], 
        
        ['0x6aaaa', '0x9aaaa', '0xa6aaa', '0xa9aaa', '0xaa6aa', '0xaa9aa', '0xaaa6a', '0xaaa9a', '0xaaaa6', '0xaaaa9'], 
        
        ['0x5aaaa', '0x96aaa', '0xa5aaa', '0xa96aa', '0xaa5aa', '0xaa96a', '0xaaa5a', '0xaaa96', '0xaaaa5'], 
        
        ['0xaaaaa', '0xaaaaa', '0xaaaaa', '0xaaaaa', '0xaaaaa', '0xaaaaa', '0xaaaaa', '0xaaaaa', '0xaaaaa', '0xaaaaa', '0xaaaaa']]
        """
    hex_cols = []
    
    #print("hexrows", hex_rows)
                
    for i,r in enumerate(rows):
        r_new = [tuple(x) for x in r]

       
        rows_len.append(len(list(set(r_new))))
        
        allowabler = allowable(r)
        ans = ""
        for i in allowabler:
            f = '{0:02b}'.format(i)
            
            ans+=f
        
        can_d_hex.append(hex(int("0b" +(str(ans)),2)))
        can_do.append(allowable(r))
        
    hex_rows = list(map(turn_into_hex, rows))
    
    #print("candohex", turn_into_hex1(can_do))
    
    print("bb",can_d_hex)
    
    
    print("CAND)", can_do)
        


    
 
    # Initially mark all columns for update.
    mod_rows, mod_cols = set(), set(range(w))

    mod_rows_in = [0]*h

    mod_cols_in = [1]*w
    
    counter = 0

    while sum(mod_cols_in) >0:
        
        for i in range(w):
            if mod_cols_in[i]:
                fix_col(i, counter)
        mod_cols_in = [0] * w
        
        #print("oteration mod rows in", mod_rows_in, counter)
        for j in range(h):
            if mod_rows_in[j]:
                fix_row(j)
        mod_rows_in = [0] * h
        counter+=1
    #print("coutner", counter)


 
 
    if all(can_do[i][j] in (1, 2) for j in range(w) for i in range(h)):
        print("Solution would be unique")  # but could be incorrect!
    else:
        print("Solution may not be unique, doing exhaustive search:")

   
 
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
   



