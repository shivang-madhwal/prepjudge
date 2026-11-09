import {expect,test} from 'vitest';
import {languages,starter,draftKey} from '../lib/starters';
test('each supported language has a stdin/stdout starter',()=>{for(const language of languages){expect(starter(language).length).toBeGreaterThan(100);}expect(starter('python')).toContain('json.loads');expect(starter('java')).toContain('public class Main');expect(starter('cpp')).toContain('int main');});
test('drafts are separated by problem and language',()=>{expect(draftKey('pair-indices','python')).not.toBe(draftKey('pair-indices','java'));expect(draftKey('pair-indices','python')).not.toBe(draftKey('step-count','python'));});
