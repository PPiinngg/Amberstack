fn math_op(op: u8, v1: isize, v2: isize) !isize {
    switch (op) {
        '/' => return v1 / v2,
        '*' => return v1 * v2,
        '+' => return v1 + v2,
        '-' => return v1 - v2,
    }
    return error{InvalidOperator};
}
