import {expect,test} from "vitest";
import {GET} from "../app/api/health/route";
test("web health responds with service identity",async()=>{const response=GET();expect(response.status).toBe(200);expect(await response.json()).toEqual({status:"UP",service:"prepjudge-web"});});
