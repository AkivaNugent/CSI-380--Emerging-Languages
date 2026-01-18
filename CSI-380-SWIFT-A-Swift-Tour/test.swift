class Person {
    let name: String
    init(name: String) {
        self.name = name
    }
}

var person1: Person?
var person2: Person?
var person3: Person?
var person4: Person?

person1 = Person(name: "Tom Smith")
person2 = person1
person3 = person1
person4 = person3