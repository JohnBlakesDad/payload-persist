#!/usr/bin/perl

# Note: The above line starts interpreter languages such as perl and shell
#
# Now that you have seen scalars and arrays in action, I will introduce you to the hashes, sometimes known as associative arrays.

# A hash is an array of key and value pairs.  The most commonly seen hash in linux is the enviromental variable list.  It constists of keys like USER and DISPLAY.

# When you print then env command you get:

# DISPLAY=111.333.222.333:0.0
# USER=John_van_Vlaanderen

# DISPLAY and USER are keys, the values are my name and the ip address/display number.

# A hash starts with a "%" sign and is similar to arrays in some respects:

%my_hash = ( 'a', 1, 'b', 2, 'c', 3, 'd' , 0, 'e', 0) ;

# Here the keys are a, b, d and d and the values are 1 2 3 1
# The operator "keys" is used below:

@keys_arr = keys %my_hash ;

# I will also introduce you to the "if", "elsif" and "else" operators
  
$last_value = 0 ;

foreach $key (@keys_arr) {

   $value = $my_hash{ $key } ;

   print "key: ".$key.", value: ".$value."\n" ;

   if ( $value > $last_value ) { 
      print "this value is greater than the prevous value in the hash\n" 
   }
   elsif ( $value == $last_value ) { 
      print "this value EQUALS the last\n"
   }
   else { 
      print "this value is NOT greater than the last\n"
   }

   $last_value = $value 
}

# This "if/else" statement has two statement blocks in it.   If I had put the a semicolon after the if statment the else statement would have left all alone. 

# Also, you dont have to use a semicolon on the last or only line in a block

