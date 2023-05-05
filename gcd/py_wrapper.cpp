#include <verilated.h>
#include "VGCD.h"

extern "C" void* createModule()
{
	auto m = new VGCD;
	//printf("creating module VGCD ptr 0x%p\n", m);
	return m;
}

enum InputPin
{
	clk=0,
    start,
    A,
    B
};
enum OutputPin
{
	RESULT=0,
    done
};
extern "C" void set(void * m_, int id, int value)
{
	auto *m = reinterpret_cast<VGCD*>(m_);
	if (clk==id) m->clk=value;
    else if(start==id) m->start=value;
    else if(A==id) m->A=value;
    else if(B==id) m->B=value;
	else printf("ERROR: invalid input pin id %d\n", id);
	//printf("set : module VGCD ptr 0x%p input id %d, value %d\n", m_, id, value);
}

extern "C" int get(void *m_, int id)
{
	//printf("get : module VGCD ptr 0x%p input id %d\n", m_, id);
	auto *m = reinterpret_cast<VGCD*>(m_);
	if (RESULT==id) return m->RESULT;
	else if (done==id) return m->done;
	else printf("ERROR: invalid input pin id %d\n", id);
}

extern "C" void eval(void *m)
{
	reinterpret_cast<VGCD*>(m)->eval();
}

extern "C" void tick(void *m_)
{
	auto *m = reinterpret_cast<VGCD*>(m_);
	m->clk = 0; m->eval();
	m->clk = 1; m->eval();
}

extern "C" void freeModule(void *m)
{
	//printf("deleting module VGCD ptr 0x%p\n", m);
	delete reinterpret_cast<VGCD*>(m);
}
