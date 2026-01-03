# 입출력

```java
// 입출력
BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
StringTokenizer st = new StringTokenizer(br.readLine());

int a = Integer.parseInt(st.nextToken());
int b = Integer.parseInt(st.nextToken());

        
```

# 해쉬(파스타맛집)

- 없는값 조회시 에러 대신 null 리턴
- 중복을 포함하지 않는다면 HashSet 고려

```java
HashMap<String, Integer> map = new HashMap<>(); // 참조형!

조회: map.getOrDefault(key, 디폴트값); // 있는지 없는지를 분기 처리해야할 때 이거로 한번에 조회랑 동시에 할 수 있음(완주하지 못한 선수)

cnt 증가: map.put(key, map.getOrDefault(key, 0)+1);

```

- HashSet은 값만 저장. key로 그 값을 저장하고 value는 더미
    - 키로 값을 찾기보단 순수 중복제거 목적

# 배열

- 동적 배열 arraylist는 중간 삽입이 선형시간이므로 처음~중간 데이터 삽입이 빈번하면 펑

```java
// array inplace 정렬
Arrays.sort(arr);

// 스트림 정렬(리턴타입 변환: Integer -> int)
arrayList.stream().sorted().mapToInt(Integer::intValue).toArray();

// reverse 정렬
Arrays.sort(arr, Collections.reverseOrder());

// 내용 출력
sout(Arrays.toString(arr));

// 정수배열 중복 제거 스트림사용(역순 정렬을 후에 하려면 Integer여야해서 boxed 상ㅇ)
Integer[] result = Arrays.stream(arr).boxed().distinct()
	.toArray(Integer[]::new);
	
	(근데 그냥 TreeSet에 넣고 나중에 리스트에 할당해도 됨)
	
// 그냥 정렬만 나중에 할거면 boxed 필요없음
Arrays.stream(arr).distinct().toArray();

// max()에 대응
int max = Arrays.stream(cnt).max().getAsInt();

// 빈 int 배열 생성
int arr = new int[원하는 수];

 

```


# 문자열
```java
// 문자열 순회
s.charAt(idx);


```

# 스택, 큐
- 가장 가까운(최근의, 직전의) 데이터를 대상으로 뭔가 연산을 하는 구조라면 스택
- empty일 때 pop, peek은 에러임을 명심
- ArrayDeque 사용하기
- 앞부터 사용, 순서를 준수 << 이런 느낌이면 큐