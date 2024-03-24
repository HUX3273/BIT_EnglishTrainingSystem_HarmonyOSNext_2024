export class LoginBySmsArgs {
  phone: string
  code: string
  clientUserType: string
  platformType: number
  version: string

  constructor(phone: string, code: string, clientUserType: string, platformType: number, version: string) {
    this.phone = phone
    this.code = code
    this.clientUserType = clientUserType
    this.platformType = platformType
    this.version = version

  }



  public getPhone(): string {
    return this.phone
  }

  public setPhone(phone: string) {
    this.phone = phone
  }

  public getCode(): string {
    return this.code
  }

  public setCode(code: string) {
    this.code = code
  }

  public getClientUserType(): string {
    return this.clientUserType
  }

  public setClientUserType(clientUserType: string) {
    this.clientUserType = clientUserType
  }

  public getPlatformType(): number {
    return this.platformType
  }

  public setPlatformType(platformType: number) {
    this.platformType = platformType
  }

  public getVersion(): string {
    return this.version
  }

  public setVersion(version: string) {
    this.version = version
  }
}