import SwiftUI

struct DocumentCardView: View {
    let applicant: Applicant

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            passportCard
            if let permit = applicant.entryPermit {
                entryPermitCard(permit)
            }
            if let card = applicant.idCard {
                idCardCard(card)
            }
        }
    }

    private var passportCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("PASSPORT").font(.caption).bold().foregroundStyle(.secondary)
                Spacer()
                Text(applicant.passport.issuingCity).font(.caption2).foregroundStyle(.secondary)
            }
            HStack(alignment: .top, spacing: 12) {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 74)
                    .overlay(Image(systemName: "person.fill").foregroundStyle(.secondary))
                VStack(alignment: .leading, spacing: 3) {
                    field("Name", applicant.passport.name)
                    field("Nationality", applicant.passport.nationality)
                    field("Sex", applicant.passport.sex)
                    field("Date of Birth", applicant.passport.dateOfBirth.formatted)
                    field("Expires", applicant.passport.expirationDate.formatted)
                    field("No.", applicant.passport.passportNumber)
                }
            }
        }
        .padding(10)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.secondary.opacity(0.4)))
    }

    private func entryPermitCard(_ permit: EntryPermit) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("ENTRY PERMIT").font(.caption).bold().foregroundStyle(.secondary)
            field("Name", permit.name)
            field("Purpose", permit.purpose)
            field("Expires", permit.expirationDate.formatted)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.secondary.opacity(0.4)))
    }

    private func idCardCard(_ card: IDCard) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text("ID CARD").font(.caption).bold().foregroundStyle(.secondary)
            field("Name", card.name)
            field("Height", "\(card.heightCm) cm")
            field("Weight", "\(card.weightKg) kg")
            field("Nationality", card.nationality)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color(.systemBackground)))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(.secondary.opacity(0.4)))
    }

    private func field(_ label: String, _ value: String) -> some View {
        HStack(spacing: 4) {
            Text("\(label):").font(.caption2).foregroundStyle(.secondary)
            Text(value).font(.caption).bold()
        }
    }
}
