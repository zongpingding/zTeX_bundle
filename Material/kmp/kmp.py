def kmp_search(text, pattern):
    def build_pi(p):
        m = len(p)
        pi = [0] * m
        j = 0
        for i in range(1, m):
            while j > 0 and p[i] != p[j]:
                j = pi[j - 1]
            if p[i] == p[j]:
                j += 1
                pi[i] = j
        return pi

    n, m = len(text), len(pattern)
    pi = build_pi(pattern)
    j = 0
    for i in range(n):
        while j > 0 and text[i] != pattern[j]:
            j = pi[j - 1]
        if text[i] == pattern[j]:
            j += 1
        if j == m:
            return True 
    return False



pattern = "abcd"
text = "123abcba321"
if pattern in text:
    print("Found")
else:
    print("Not Found")
