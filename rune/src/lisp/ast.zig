pub const Atom = union(enum(u8)) {
    List: []Atom,
    Identifier: []u8,
    String: []u8,
    Number: f64,
    Boolean: bool,
};
