#=
Grammar:
<exp>    ::= <term><exp'>
<exp'>   ::= +<term><exp'> | - <term><exp'> | ϵ
<term>   ::= <factor><term'>
<term'>  ::= *<factor><term'> | / <factor><term'> | ϵ
<factor> ::= (<exp>) |<ident>|<num>
<ident>  ::= A|B|...|Z
<num>    ::  Real, let's assume all Float64 numbers
=#

#=
<exp> -> <exp> + <term>
|        <exp> - <term> 
<term> -> <term> * <factor>
        <term> - <factor> 


=#

#= 
   Recursive descent parser. 
   We do LL(1). That is left-to-right leftmost derivation  
=#

#= 
 Let's construct one method for each non terminal.
 We also have a method scanm that updates our current token. 
 The current token represent our look-ahead of 1.
 
 The parser use K allows a recursive descent parser to decide which production 
 to use by examining only the next k tokens of input

=#


global current_token = ""

function scan()
  res = read(stdin, Char)
  global current_token = string(res)
  return string(res)
end

function main()
  while true
    print("Enter expression  => ")
    scan()
    res = exp()
    println("Result of res is: $res")
  end
end

function exp()
  res = term()
  res = expPrime(res)
  return res
end

function term()
  res = factor()
  res = termPrime(res)
  return res
end

function expPrime(res)
  if current_token == "+"
    scan()
    res = res + term()
    return expPrime(res)
  elseif current_token == "-"
    scan()
    res = res - term()
    return expPrime(res)
  else #= ϵ =#
    return res
  end
end

function termPrime(res)
  if current_token == "*"
    scan()
    res = res * factor()
    return termPrime(res)
  elseif current_token == "/"
    scan()
    res = res / factor()
    return termPrime(res)
  else #= ϵ =#
    return res
  end
end

function factor()
  if current_token == "("
    scan()
    res = exp()
    if current_token != ")"
      throw("Right parenthesis expected")
    else
      scan()
      return res
    end
  elseif nothing != match(r"[A-Z]+", current_token)
    throw("TODO: Not implemented, do as an exercise at home:)")
  elseif nothing != match(r"[1-9]+", current_token)
    res = parse(Float64, current_token)
    scan()
    return res
  else #= Faulty input =#
    throw("Unexpected token: $(current_token)")
  end
end

main()
