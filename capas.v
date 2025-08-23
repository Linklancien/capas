module capas

pub struct Token{
mut:
	pv	Mark
	marks []Mark
}

fn (tok Token) turn() {
	if tok.pv.effect(){
		
	}
}

struct Mark{
	quantity int
	effect   fn
}