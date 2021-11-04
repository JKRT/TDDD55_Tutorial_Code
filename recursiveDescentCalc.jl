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
   Recursive descent parser. 
   We do LL(1). That is left-to-right leftmost derivation  
=#

#= 
 Let's construct one method for each non terminal.
 Let's assume that we have the method scan that updates our global token.
=#


global identLevel = 0
global current_token = ""

function print_and_ident(str::String)
  ident = ""
  for i in 1:identLevel
    ident *= "\t"
  end
  println("$ident $str")
end

function scan()
  res = read(stdin, Char)
  global current_token = string(res)
  return string(res)
end

function main()
  scan()
  res = 0
  res = exp(res)
  println("Result of res is: $res")
end

function exp(res)
  res = term(res)
  res = expPrime(res)
end

function term(res)
  res = factor(res)
  termPrime(res)
end

function expPrime(res)
  if current_token == "+"
    scan()
    res = res + term(res)
    expPrime(res)
  elseif current_token == "-"
    scan()
    res = res - term(res)
    expPrime(res)
  else #= ϵ =#
    return res
  end
end

function termPrime(res)
  if current_token == "*"
    scan()
    res = res * factor(res)
    termPrime(res)
  elseif current_token == "/"
    scan()
    res = res / factor(res)
    termPrime(res)
  else #= ϵ =#
    return res
  end
end

function factor(res)  
  if current_token == "("
    scan()
    res = exp(res)
    if current_token != ")"
      throw("Right parenthesis expected")
    end
    scan()
    return res
  elseif nothing != match(r"[A-Z]+", current_token)
    res = parse(Float64, current_token)
    scan()
    return res
  elseif nothing != match(r"[0-9]+", current_token)
    res = parse(Float64, current_token)
    scan()
    return res 
  else #= Faulty input =#
    throw("Unexpected token: $(current_token)")
  end
end


main()
