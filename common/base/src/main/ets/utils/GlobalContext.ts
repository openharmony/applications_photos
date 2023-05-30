
export class GlobalContext {
    private constructor() { }
    private static instance: GlobalContext;
    private _objects = new Map<string, any>();

    public static getContext(): GlobalContext {
        if (!GlobalContext.instance) {
            GlobalContext.instance = new GlobalContext();
        }
        return GlobalContext.instance;
    }

    getObject(value: string): any {
        return this._objects.get(value);
    }

    setObject(key: string, objectClass: any) {
        this._objects.set(key, objectClass);
    }
}