// PGM 베스트앨범
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <map>

using namespace std;

vector<int> solution(vector<string> genres, vector<int> plays) {
    vector<int> answer;

    // 1. 장르 합 구하기
    map<string, int> gSum;
    for (int i=0; i<genres.size(); ++i) {
        gSum[genres[i]] += plays[i];
    }
    // 장르 합 별로 내림차순
    vector<pair<string, int>> v(gSum.begin(), gSum.end());
    sort(v.begin(), v.end(), [&](auto& a, auto& b){ return a.second > b.second; });
    map<string, int> rank; // 장르 - 랭크
    for (int i=0; i<v.size(); ++i)
        rank[v[i].first] = i;
    // 2. 재생 횟수 별로 줄세우기
    vector<int> id;
    for (int i=0; i<plays.size(); ++i) id.push_back(i);
    sort(id.begin(), id.end(), [&](auto& a, auto& b){
        if (genres[a] != genres[b]) return rank[genres[a]] < rank[genres[b]];
        if (plays[a] != plays[b]) return plays[a] > plays[b];
        return a < b;
    });
    // 3. 결과
    map<string, int> cnt;
    for (int i=0; i<id.size(); ++i) {
        if (cnt[genres[id[i]]] < 2) {
            cnt[genres[id[i]]] += 1;
            answer.push_back(id[i]);
        }
    }

    return answer;
}
