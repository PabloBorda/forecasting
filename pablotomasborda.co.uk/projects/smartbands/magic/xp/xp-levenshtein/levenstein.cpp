/*
 * =====================================================================================
 *
 *       Filename:  levenstein.cpp
 *
 *    Description:  Calculates computational distance between two files
 *
 *        Version:  1.0
 *        Created:  10/21/09 19:10:17
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Pablo Tomas Borda Di Berardino
 *        Company:  
 *
 * =====================================================================================
 */
#include "../xp-commons/levenshtein.h"
#include <iostream>



using namespace std;


int main(int argc,char *argv[]){

  if (argc != 3) {
    cout << "Usage: levenshtein file1 file2\n";
  } else {
    Levenshtein *comparator =   new Levenshtein();
    cout << comparator->levenshtein(argv[1],argv[2]);
  }
  return 0;
}

