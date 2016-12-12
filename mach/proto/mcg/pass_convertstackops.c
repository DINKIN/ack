#include "mcg.h"

static PMAPOF(struct basicblock, struct ir) pops;
static PMAPOF(struct basicblock, struct ir) pushes;

static struct ir* get_last_push(struct basicblock* bb)
{
    int i;

    for (i=bb->irs.count-1; i>=0; i--)
    {
        struct ir* ir = bb->irs.item[i];

        if (ir->opcode == IR_PUSH)
            return ir;
        if (ir_find(ir, IR_POP))
            return NULL;
    }

    return NULL;
}

static struct ir* get_first_pop(struct basicblock* bb)
{
    int i;

    for (i=0; i<bb->irs.count; i++)
    {
        struct ir* irr;
        struct ir* ir = bb->irs.item[i];

        if (ir->opcode == IR_PUSH)
            return NULL;

        irr = ir_find(ir, IR_POP);
        if (irr)
            return irr;
    }

    return NULL;
}

static void convert_block(struct basicblock* bb)
{
    int i, j;
    struct ir* ir;

    pushes.count = pops.count = 0;
    for (;;)
    {
        struct ir* lastpush = get_last_push(bb);
        if (!lastpush)
            return;

        /* Abort unless *every* successor block of this one starts with a pop
         * of the same size... */

        for (i=0; i<bb->nexts.count; i++)
        {
            struct basicblock* outbb = bb->nexts.item[i];

            ir = get_first_pop(outbb);
            if (!ir || (ir->size != lastpush->size))
                return;
            pmap_add(&pops, outbb, ir);

            /* Also abort unless *every* predecessor block of the one we've
             * just found *also* ends in a push of the same size. */

            for (j=0; j<outbb->prevs.count; j++)
            {
                struct basicblock* inbb = outbb->prevs.item[j];

                ir = get_last_push(inbb);
                if (!ir || (ir->size != lastpush->size))
                    return;
                pmap_add(&pushes, inbb, ir);
            }
        }

        /* If we didn't actually find anything, give up. */

        if ((pushes.count == 0) || (pops.count == 0))
            return;
            
        /* Okay, now we can wire them all up. */

        for (i=0; i<pushes.count; i++)
        {
            struct ir* ir = pushes.item[i].right;
            ir->opcode = IR_NOP;
        }

        for (i=0; i<pops.count; i++)
        {
            struct basicblock* outbb = pops.item[i].left;
            struct ir* ir = pops.item[i].right;

            assert(pushes.count > 0);

            struct ir* phi = new_ir0(IR_PHI, ir->size);
            for (j=0; j<pushes.count; j++)
            {
                pmap_add(&phi->u.phivalue,
                    pushes.item[j].left,
                    pushes.item[j].right);
            }
            phi->root = phi;
            phi->bb = ir->bb;
            *ir = *phi;
        }
    }
}

void pass_convert_stack_ops(void)
{
    int i;

    for (i=0; i<cfg.preorder.count; i++)
        convert_block(cfg.preorder.item[i]);
}

/* vim: set sw=4 ts=4 expandtab : */
