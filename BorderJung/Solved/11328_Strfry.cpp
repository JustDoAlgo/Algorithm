// #include <iostream>
// #include <vector>
// using namespace std;

// int main()
// {
//     cin.tie(0);
//     ios::sync_with_stdio(false);

//     int n; cin >> n;

//     while (n-- > 0)
//     {
//         bool isPossible = true;
        
//         string a, b;
//         cin >> a >> b;
//         vector<int> va(26, 0);
//         vector<int> vb(26, 0);
        
//         for (char e : a) va[e - 'a'] += 1;
//         for (char e : b) vb[e - 'a'] += 1;

//         for (int i=0; i<26; ++i)
//         {
//             if (va[i] != vb[i])
//             {
//                 isPossible = false;
//                 break;
//             }
//         }

//         if (isPossible)
//             cout << "Possible\n";
//         else
//             cout << "Impossible\n"; 
        
//     }
// }

// 제미나이
// string도 sort가 된다... 깜쌈한데
#include <iostream>
#include <algorithm>
using namespace std;

void solve() {
    string a, b;
    cin >> a >> b;
    sort(a.begin(), a.end());
    sort(b.begin(), b.end());

    if (a == b) {
        cout << "Possible\n";
    } else {
        cout << "Impossible\n";
    }
}

int main() {
    ios::sync_with_stdio(0);
    cin.tie(0);

    int t;
    cin >> t;
    while (t--) {
        solve();
    }
}