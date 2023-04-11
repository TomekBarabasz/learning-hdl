#include <iostream>
#include <verilated.h>
#include "VGCD.h"
#include "gtest/gtest.h"

#define TICK \
	m->clk = 0; m->eval();\
	m->clk = 1; m->eval();

class TestSuite : public ::testing::Test
{
public:
    void SetUp()
    {
        m = new VGCD;
    }

    void TearDown()
    {
        delete m;
    }
	VGCD *m;
};

TEST_F(TestSuite, ALL_ZERO)
{
	m->start = 1;
	m->A=0;
	m->B=0;
	TICK;
	EXPECT_EQ(1, m->done);
	EXPECT_EQ(0, m->RESULT);
	
	m->start = 1;
	m->A=1;
	m->B=0;
	TICK;
	TICK;
	EXPECT_EQ(1, m->done);
	EXPECT_EQ(1, m->RESULT);
}
