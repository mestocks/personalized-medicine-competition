#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#include <rwk_parse.h>
#include <rwk_htable.h>

#define MAX_WORD 512
#define MAX_WORDS 1000000

// chargrok <wordlist.txt> <text>
// wordlist.txt - 1 column, unique word per line
// text - 3 columns, <id> <word> <#/id>

void zero_htable(struct rwkHashTable *hash, char **uwords, int nuwords)
{
  int i, index;
  struct rwkHashll *node;
  for (i = 0; i < nuwords; i++) {
    index = rwk_index_hash(uwords[i], hash->size);
    node = hash->llptr[index];
    while (strcmp(node->key, uwords[i]) != 0) {
      node = node->next;
    }
    strcpy(node->value, "0");
  }
}


void print_word_counts(struct rwkHashTable *hash, char **uwords, int nuwords)
{
  int i;
  char *value;

  value = (char*)rwk_lookup_hash(hash, uwords[0]);
  printf("%s", value);
  for (i = 1; i < nuwords; i++) {
    value = (char*)rwk_lookup_hash(hash, uwords[i]);
    printf(" %s", value);
  }
  printf("\n");
}

int main(int argc, char **argv)
{
  int i;
  FILE *fp;
  char *tmp;
  struct rwkHashTable hash;
  char *key;
  char *value;
  char buffer[MAX_WORD];

  int nuwords;
  char **uwords;

  uwords = calloc(MAX_WORDS, sizeof (char*));
  rwk_create_hash(&hash, 10000000);
  
  fp = fopen(argv[1], "r");

  i = 0;
  while (fgets(buffer, MAX_WORD, fp)) {
    tmp = buffer;
    while (*tmp != '\n') {
      tmp++;
    }
    *tmp = '\0';
    key = calloc(MAX_WORD, sizeof (char));
    value = calloc(MAX_WORD, sizeof (char));
    strcpy(key, buffer);
    strcpy(value, "0");
    rwk_insert_hash(&hash, key, value);
    uwords[i] = calloc(MAX_WORD, sizeof (char));
    strcpy(uwords[i], buffer);
    i++;
  }
  nuwords = i;

  int ncols;
  int index;
  FILE *fpmain;
  char **array;
  char delim = ' ';

  ncols = 3;
  array = calloc(ncols, sizeof (char*));
  fpmain = fopen(argv[2], "r");

  int nr;
  char *tmp_id;
  struct rwkHashll *node;

  tmp_id = calloc(MAX_WORD, sizeof (char));
  
  nr = 0;
  while (fgets(buffer, MAX_WORD, fpmain)) {
    rwk_str2array(array, buffer, ncols, &delim);
    if (nr == 0) {
      strcpy(tmp_id, array[0]);
    }
    if (nr != 0 && strcmp(array[0], tmp_id) != 0) {
      print_word_counts(&hash, uwords, nuwords);
      zero_htable(&hash, uwords, nuwords);
      strcpy(tmp_id, array[0]);
    }
    index = rwk_index_hash(array[1], hash.size);
    node = hash.llptr[index];

    while (node != NULL && strcmp(node->key, array[1]) != 0) {
      node = node->next;
    }
    if (node != NULL) {
      strcpy(node->value, array[2]);
    }
    nr++;
  }
  print_word_counts(&hash, uwords, nuwords);

  free(tmp_id);
  fclose(fpmain);
  free(array);
  for (i = 0; i < nuwords; i++) {
    free(uwords[i]);
  }

  free(uwords);
  fclose(fp);
  rwk_free_hash(&hash);
  
  return 0;
}
