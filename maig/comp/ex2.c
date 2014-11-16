#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <time.h>

#define NUM_STRATEGY 5151

typedef struct {
	int r, p, s, wins;
} Strategy;

Strategy sset[NUM_STRATEGY];
int spointer = 0;

void append_strategy(int r, int p, int s) {
	sset[spointer].r = r;
	sset[spointer].p = p;
	sset[spointer].s = s;
	spointer++;
}

void gen_strategies(void) {
	int r, p, s;
	for (r = 0; r <= 100; r++) {
		for (p = 0; p <= (100-r); p++) {
				s = 100-r-p;
				append_strategy(r, p, s);
		}
	}
}

char get_strategy(int c, Strategy p) {
	if (c <= p.r) {
		return 'r';
	} else if (c <= (p.r + p.p)) {
		return 'p';
	} else {
		return 's';
	}
}

/* Do a round */
void do_round(int p1, int p2) {
	int outcome = (get_strategy(rand() % 100 + 1, sset[p1]) << 0x08)
								| get_strategy(rand() % 100 + 1, sset[p2]);
	switch (outcome) {
		/* r - r */
		case 0x7272:
			/* draw */
			break;
		/* r - p */
		case 0x7270:
			/* p2 wins */
			sset[p2].wins++;
			break;
		/* r - s */
		case 0x7273:
			/* p1 wins */
			sset[p1].wins++;
			break;
		/* p - r */
		case 0x7072:
			/* p1 wins */
			sset[p1].wins++;
			break;
		/* p - p */
		case 0x7070:
			/* draw */
			break;
		/* p - s */
		case 0x7073:
			/* p2 wins */
			sset[p2].wins++;
			break;
		/* s - r */
		case 0x7372:
			/* p2 wins */
			sset[p2].wins++;
			break;
		/* s - p */
		case 0x7370:
			/* p1 wins */
			sset[p1].wins++;
			break;
		/* s - s */
		case 0x7373:
			/* draw */
			break;
	}
}

int cmp_wins(Strategy *elem1, Strategy *elem2) {
	if (elem1->wins < elem2->wins) {
		return 1;
	} else if (elem1->wins > elem2->wins) {
		return -1;
	} else {
		return 0;
	}
}

int main(int argc, char * argv[]) {
	/* i = current strategy, r = round , o = opponent */
	int i, r, o;
	gen_strategies();
	/* Seed rand gen */
	srand (time(NULL));
	for (i = 0; i < NUM_STRATEGY; i++) {
		printf("%d/%d\n", i, NUM_STRATEGY);
		//printf("%d: %d, %d, %d\n", i, sset[i].r, sset[i].p, sset[i].s);
		for (o = 0; o < NUM_STRATEGY; o++) {
			if (r != i) {
				for (r = 0; r < 300; r++) {
					do_round(i, o);
				}
			}
		}
	}
	puts("DONE. Sorting results....\n");
	qsort(sset, NUM_STRATEGY, sizeof(Strategy), cmp_wins);
	for (i = 0; i < 100; i++) {
		printf("%d, %d-%d-%d; wins: %d\n", i, sset[i].r, sset[i].p, sset[i].s, sset[i].wins);
	}
}
