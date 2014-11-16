#include <stdio.h>
#include <pthread.h>

#define NUM_STRATEGY 4598126
#define NUM_THREADS 8

typedef struct {
  int dist[5];
  unsigned long wins;
} Strategy;

int spointer = 0;

Strategy sset[NUM_STRATEGY];
pthread_t workers[NUM_THREADS];
pthread_mutex_t mtex = PTHREAD_MUTEX_INITIALIZER;

void add_strategy(int a, int b, int c, int d, int e) {
  sset[spointer].dist[0] = a;
  sset[spointer].dist[1] = b;
  sset[spointer].dist[2] = c;
  sset[spointer].dist[3] = d;
  sset[spointer].dist[4] = e;
  sset[spointer].wins = 0;
  spointer++;
}

int get_next(void) {
  int a;
  pthread_mutex_lock(&mtex);
  printf("Cur: %d\n", spointer);
  if (spointer >= NUM_STRATEGY) {
    a = -1;
  } else {
    a = spointer;
    spointer += 1000;
  }
  pthread_mutex_unlock(&mtex);
  return a;
}

void *worker(void  * p) {
  int i, o, c, s, p1, p2, cur;
  while ((c = get_next()) != -1) {
    /* for each in the block of 1k */
    for (i = 0; (i < 1000) && (i < (NUM_STRATEGY)); i++) {
      cur = c + i;
      /* For each competing strategy */
      for (o = 0; o < (NUM_STRATEGY); o++) {
        if (o != cur) {
          p1 = 0;
          p2 = 0;
          /* For each site */
          for (s = 0; s < 5; s++) {
            if (sset[cur].dist[s] > sset[o].dist[s]) {
              p1++;
            }
            else if (sset[o].dist[s] > sset[cur].dist[s]) {
              p2++;
            }
          }
          /* Update winnings */
          if (p1 > p2) sset[cur].wins++;
        }
      }
    }
  }
  return NULL;
}

void generate_strategies(void) {
  Strategy * s;
  int a, b, c, d, e, i = 0;
  for (a = 0; a <= 100; a++) {
    for (b = 0; b <= (100-a); b++) {
      for (c = 0; c <= (100-a-b); c++) {
        for (d = 0; d <= (100-a-b-c); d++) {
          e = 100 - (a + b + c + d);
          //printf("%d: %d-%d-%d-%d-%d\n", i++, a, b, c, d, e);
          add_strategy(a, b, c, d, e);
        }
      }
    }
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
  int t, i;
  puts("Generating strategies...");
  generate_strategies();
  puts("Done. Starting Workers.");
  spointer = 0;
  for (t = 0; t < (NUM_THREADS); t++) {
    printf("Starting thread %d\n", t);
    pthread_create(&(workers[t]), NULL, worker, NULL);
  }

  for (t = 0; t < (NUM_THREADS); t++)
    pthread_join(workers[t], NULL);
  puts("DONE. Sorting results....");

  qsort(sset, NUM_STRATEGY, sizeof(Strategy), cmp_wins);
  for (i = 0; i < 100; i++) {
    printf("%d, %d-%d-%d-%d-%d; wins: %lu\n", i, sset[i].dist[0], sset[i].dist[1], sset[i].dist[2], sset[i].dist[3], sset[i].dist[4], sset[i].wins);
  }
  return 0;
}
