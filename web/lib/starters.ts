export const languages = ["python", "java", "cpp"] as const;
export type Language = typeof languages[number];
export function starter(language: Language): string {
 const code = {
 python: `import json
import sys

def solve(data):
    # Implement your approach here.
    pass

if __name__ == "__main__":
    data = json.loads(sys.stdin.read())
    print(json.dumps(solve(data)))
`,
 java: `import java.io.*;

public class Main {
    public static void main(String[] args) throws Exception {
        String input = new String(System.in.readAllBytes());
        // Parse the JSON input and implement your approach.
        // Write exactly one JSON result to stdout.
    }
}
`,
 cpp: `#include <iostream>
#include <string>
#include <iterator>

int main() {
    std::string input((std::istreambuf_iterator<char>(std::cin)), {});
    // Parse the JSON input and implement your approach.
    // Write exactly one JSON result to stdout.
    return 0;
}
`
 };return code[language];
}
export function draftKey(slug:string, language:Language){return `prepjudge.draft.v1.${slug}.${language}`;}
