// 1629
// start: 23:15
// end: 23:50
// elapsed: 35
// 비고: 어려워서 강의보고 풀음. 재귀적인 사고가 전혀 안 떠오른다.

#include <iostream>
#include <math.h>
using namespace std;
using ll = long long;

/*
a^1과 a^k를 알면 a^(2k)와 a^(2k+1)을 바로 구할 수 있지.
다시 말해 a^(2k)를 구하려면, a^k * a^k 를 구하면 된다는 뜻
만약 a^(2k+1)을 구하려면, a^k * a^k * a 를 구하면 된다는 뜻
이를 통해 귀납적 사고로 논리식을 전개해보자

목표: a^b 구하기
귀납적 사고
- a^b = a^(b/2)*a^(b/2)
      = a^(b/4)*a^(b/4)*a^(b/4)*a^(b/4)
      = a^(b/8)*a^(b/8)*a^(b/8)*a^(b/8)*a^(b/8)*a^(b/8)*a^(b/8)*a^(b/8)
      = ...
      = a*a*a*a*a*...
- 재귀로 풀겠다는 생각이 든다!
*/
ll POW(ll a, ll b, ll c)
{
    if (b == 1) return a % c;
    ll val = POW(a, b/2, c);
    val = val * val % c;
    if (b % 2 == 0) return val;
    return val * a % c;   
}

int main()
{
    cin.tie(0);
    cout.tie(0);
    ios::sync_with_stdio(false);

    int a, b, c; cin >> a >> b >> c;
    cout << POW(a, b, c);
}