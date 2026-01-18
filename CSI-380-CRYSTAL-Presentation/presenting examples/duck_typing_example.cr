# Example of Pseudo-Duck Typing in Crystal

# "If it looks like a duck, swims like a duck, 
#  and quacks like a duck, 
#  then it probably is a duck."

class Duck
    def quack
        "quack!"
    end
    def is_a_duck?
        true
    end
end

class Doctor
    def quack
        true
    end
end

# we can pass in anything with a quack method
def does_it_quack(duck_like_thing)
    puts duck_like_thing.quack
    puts duck_like_thing.is_a_duck?
end

d = Duck.new
p = Doctor.new

does_it_quack(d) # Outputs the string "quack!""
does_it_quack(p) # Outputs a bool 'true'
